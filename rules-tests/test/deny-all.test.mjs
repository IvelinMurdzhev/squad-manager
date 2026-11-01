import { readFile } from 'node:fs/promises';
import { after, before, describe, it } from 'node:test';
import { assertFails, initializeTestEnvironment } from '@firebase/rules-unit-testing';
import { collection, deleteDoc, doc, getDoc, getDocs, setDoc, updateDoc } from 'firebase/firestore';
import { deleteObject, getBytes, listAll, ref, uploadBytes } from 'firebase/storage';

const projectId = 'demo-squad-manager';
let environment;

before(async () => {
  // Never run rules tests against a live project or silently skip an emulator.
  for (const name of ['FIRESTORE_EMULATOR_HOST', 'FIREBASE_STORAGE_EMULATOR_HOST']) {
    if (!process.env[name]) throw new Error(`${name} must be set by emulators:exec`);
  }
  environment = await initializeTestEnvironment({
    projectId,
    firestore: { rules: await readFile(new URL('../../firestore.rules', import.meta.url), 'utf8') },
    storage: { rules: await readFile(new URL('../../storage.rules', import.meta.url), 'utf8') },
  });
  await environment.withSecurityRulesDisabled(async (context) => {
    for (const path of ['fixtures/existing', 'fixtures/parent/children/existing']) {
      await setDoc(doc(context.firestore(), path), { value: 'fake' });
    }
    await uploadBytes(ref(context.storage(), 'fixtures/nested/fake.txt'), new TextEncoder().encode('fake'));
  });
});

after(async () => { await environment?.cleanup(); });

for (const identity of ['anonymous', 'player', 'admin']) {
  describe(`${identity} cannot access any client data`, () => {
    const context = () => identity === 'anonymous'
      ? environment.unauthenticatedContext()
      : environment.authenticatedContext(`fake-${identity}`, identity === 'admin' ? { platformAdmin: true } : {});

    for (const path of ['fixtures/existing', 'fixtures/parent/children/existing']) {
      it(`denies all Firestore operations at ${path}`, async () => {
        const db = context().firestore();
        const existing = doc(db, path);
        await assertFails(getDoc(existing));
        await assertFails(getDocs(collection(db, path.split('/').slice(0, -1).join('/'))));
        await assertFails(setDoc(doc(db, `${path}-new`), { value: 'fake' }));
        await assertFails(updateDoc(existing, { value: 'changed' }));
        await assertFails(deleteDoc(existing));
      });
    }

    it('denies Storage reads, listing, uploads and deletes', async () => {
      const storage = context().storage();
      await assertFails(getBytes(ref(storage, 'fixtures/nested/fake.txt')));
      await assertFails(listAll(ref(storage, 'fixtures/nested')));
      await assertFails(uploadBytes(ref(storage, 'fixtures/nested/new.txt'), new TextEncoder().encode('fake')));
      await assertFails(deleteObject(ref(storage, 'fixtures/nested/fake.txt')));
    });
  });
}

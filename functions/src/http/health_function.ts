import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';
import { onRequest } from 'firebase-functions/v2/https';
import { createHealthHandler } from './health';

initializeApp();

export const health = onRequest(
  { timeoutSeconds: 15 },
  createHealthHandler({
    firestore: async () => {
      const document = getFirestore().doc('system/health');
      await document.set(
        { checkedAt: FieldValue.serverTimestamp() },
        { merge: true },
      );
      await document.get();
    },
    auth: async () => {
      await getAuth().listUsers(1);
    },
    storage: async () => {
      // Object listing is supported by the Storage emulator; bucket metadata is not.
      await getStorage()
        .bucket()
        .getFiles({ maxResults: 1, autoPaginate: false });
    },
  }),
);

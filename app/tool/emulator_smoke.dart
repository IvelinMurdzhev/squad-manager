// Run only with the emulator suite, as documented in the root README.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:squad_manager/app.dart';
import 'package:squad_manager/config/env.dart';
import 'package:squad_manager/data/services/firebase_bootstrap.dart';
import 'package:squad_manager/routing/auth_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Env.useEmulators || Env.current != AppEnv.dev) {
    throw StateError('Smoke checks require ENV=dev and USE_EMULATORS=true.');
  }
  await initializeFirebase();
  await FirebaseAuth.instance.signInAnonymously();
  debugPrint('Emulator smoke: Auth sign-in succeeded.');
  await _expectDenied(
    () => FirebaseFirestore.instance
        .doc('fixtures/fake')
        .get(const GetOptions(source: Source.server)),
    'permission-denied',
  );
  debugPrint('Emulator smoke: Firestore denied a server read.');
  await _expectDenied(
    () => FirebaseStorage.instance.ref('fixtures/fake.txt').getData(),
    'unauthorized',
  );
  debugPrint('Emulator smoke: Storage denied a read.');
  await FirebaseAuth.instance.currentUser!.delete();
  debugPrint('Emulator smoke: PASS; fake Auth user removed.');
  runApp(SquadManagerApp(authState: StubAuthState()));
}

Future<void> _expectDenied(
  Future<Object?> Function() operation,
  String code,
) async {
  try {
    await operation().timeout(const Duration(seconds: 15));
  } on FirebaseException catch (error) {
    if (error.code == code) return;
    rethrow;
  }
  throw StateError('Expected emulator rules to deny access.');
}

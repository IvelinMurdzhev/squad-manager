import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

import 'env.dart';

/// API keys are public identifiers, but they stay out of git: they are passed
/// at build time with `--dart-define-from-file=firebase_keys_<env>.json`.
/// See `firebase_keys.example.json` and the README.
abstract final class FirebaseApiKeys {
  static const String web = String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const String android = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
  );
}

/// Firebase configuration without the API key, per environment and platform.
FirebaseOptions firebaseOptionsFor(
  AppEnv environment, {
  required bool isWeb,
  required String apiKey,
}) => switch ((environment, isWeb)) {
  (AppEnv.dev, true) => FirebaseOptions(
    apiKey: apiKey,
    appId: '1:79842835454:web:396b7c830eac49d7689eaf',
    messagingSenderId: '79842835454',
    projectId: 'squad-manager-dev',
    authDomain: 'squad-manager-dev.firebaseapp.com',
    storageBucket: 'squad-manager-dev.firebasestorage.app',
    measurementId: 'G-J0D32M62R9',
  ),
  (AppEnv.dev, false) => FirebaseOptions(
    apiKey: apiKey,
    appId: '1:79842835454:android:f3e3a3f470d368a3689eaf',
    messagingSenderId: '79842835454',
    projectId: 'squad-manager-dev',
    storageBucket: 'squad-manager-dev.firebasestorage.app',
  ),
  (AppEnv.prod, true) => FirebaseOptions(
    apiKey: apiKey,
    appId: '1:96821715155:web:1231b0d61d6cee4a867426',
    messagingSenderId: '96821715155',
    projectId: 'squad-manager-de7c2',
    authDomain: 'squad-manager-de7c2.firebaseapp.com',
    storageBucket: 'squad-manager-de7c2.firebasestorage.app',
    measurementId: 'G-YEHGS84509',
  ),
  (AppEnv.prod, false) => FirebaseOptions(
    apiKey: apiKey,
    appId: '1:96821715155:android:eedd3fbfaebd54c4867426',
    messagingSenderId: '96821715155',
    projectId: 'squad-manager-de7c2',
    storageBucket: 'squad-manager-de7c2.firebasestorage.app',
  ),
};

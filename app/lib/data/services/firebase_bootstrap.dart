import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../config/env.dart';
import '../../config/firebase_options.dart';

const functionsRegion = 'europe-west3';

/// Accepted by the emulators, which never validate API keys.
const emulatorApiKey = 'emulator-api-key';

String emulatorHost({required bool isWeb, required TargetPlatform platform}) =>
    !isWeb && platform == TargetPlatform.android ? '10.0.2.2' : '127.0.0.1';

/// The Firebase SDK calls the bootstrap makes, separated so tests can record
/// them without touching a platform channel.
abstract interface class FirebaseGateway {
  Future<void> initializeApp(FirebaseOptions options);
  Future<void> useAuthEmulator(String host, int port);
  Future<void> useFirestoreEmulator(String host, int port);
  Future<void> useStorageEmulator(String host, int port);
  void useFunctionsEmulator(String region, String host, int port);
  Future<void> activateDebugAppCheck();
}

class SdkFirebaseGateway implements FirebaseGateway {
  const SdkFirebaseGateway();

  @override
  Future<void> initializeApp(FirebaseOptions options) =>
      Firebase.initializeApp(options: options);

  @override
  Future<void> useAuthEmulator(String host, int port) =>
      FirebaseAuth.instance.useAuthEmulator(host, port);

  @override
  Future<void> useFirestoreEmulator(String host, int port) async {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
    FirebaseFirestore.instance.useFirestoreEmulator(host, port);
  }

  @override
  Future<void> useStorageEmulator(String host, int port) =>
      FirebaseStorage.instance.useStorageEmulator(host, port);

  @override
  void useFunctionsEmulator(String region, String host, int port) =>
      FirebaseFunctions.instanceFor(region: region)
          .useFunctionsEmulator(host, port);

  @override
  Future<void> activateDebugAppCheck() => FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
    providerWeb: WebDebugProvider(),
  );
}

/// Configures every Firebase client before the UI can use it.
///
/// Parameters default to the build-time environment and the running platform;
/// tests override them.
Future<void> initializeFirebase({
  FirebaseGateway gateway = const SdkFirebaseGateway(),
  AppEnv? environment,
  bool? useEmulators,
  bool? isWeb,
  TargetPlatform? platform,
  String? webApiKey,
  String? androidApiKey,
}) async {
  final env = environment ?? Env.current;
  final emulated = useEmulators ?? Env.useEmulators;
  final web = isWeb ?? kIsWeb;
  final target = platform ?? defaultTargetPlatform;

  if (!web && target != TargetPlatform.android) {
    throw UnsupportedError('Firebase is configured for Android and web only.');
  }
  if (emulated && env == AppEnv.prod) {
    throw StateError('Use ENV=dev with the local emulator suite.');
  }
  final configuredKey = (web
      ? webApiKey ?? FirebaseApiKeys.web
      : androidApiKey ?? FirebaseApiKeys.android);
  if (configuredKey.isEmpty && !emulated) {
    throw StateError(
      'Missing Firebase API key. Pass '
      '--dart-define-from-file=firebase_keys_${env.name}.json (see README).',
    );
  }
  await gateway.initializeApp(
    firebaseOptionsFor(
      env,
      isWeb: web,
      apiKey: configuredKey.isEmpty ? emulatorApiKey : configuredKey,
    ),
  );

  if (emulated) {
    final host = emulatorHost(isWeb: web, platform: target);
    await gateway.useAuthEmulator(host, 9099);
    await gateway.useFirestoreEmulator(host, 8080);
    await gateway.useStorageEmulator(host, 9199);
    gateway.useFunctionsEmulator(functionsRegion, host, 5001);
    // App Check has no emulator. Avoid live token exchange and token logging.
    return;
  }

  if (env == AppEnv.dev) {
    await gateway.activateDebugAppCheck();
  }
  // Production attestation providers are configured in roadmap step 1.5.
}

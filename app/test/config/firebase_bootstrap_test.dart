import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/config/env.dart';
import 'package:squad_manager/config/firebase_options.dart';
import 'package:squad_manager/data/services/firebase_bootstrap.dart';

class _RecordingGateway implements FirebaseGateway {
  final calls = <String>[];
  final apiKeys = <String>[];

  @override
  Future<void> initializeApp(FirebaseOptions options) async {
    calls.add('init:${options.projectId}');
    apiKeys.add(options.apiKey);
  }

  @override
  Future<void> useAuthEmulator(String host, int port) async =>
      calls.add('auth:$host:$port');

  @override
  Future<void> useFirestoreEmulator(String host, int port) async =>
      calls.add('firestore:$host:$port');

  @override
  Future<void> useStorageEmulator(String host, int port) async =>
      calls.add('storage:$host:$port');

  @override
  void useFunctionsEmulator(String region, String host, int port) =>
      calls.add('functions:$region:$host:$port');

  @override
  Future<void> activateDebugAppCheck() async => calls.add('appcheck');
}

void main() {
  test('selects distinct Firebase projects for dev and prod', () {
    String project(AppEnv env, bool web) =>
        firebaseOptionsFor(env, isWeb: web, apiKey: 'k').projectId;
    expect(project(AppEnv.dev, true), 'squad-manager-dev');
    expect(project(AppEnv.prod, true), 'squad-manager-de7c2');
    expect(project(AppEnv.dev, false), 'squad-manager-dev');
    expect(project(AppEnv.prod, false), 'squad-manager-de7c2');
  });

  test('web and Android choose reachable emulator hosts', () {
    expect(
      emulatorHost(isWeb: true, platform: TargetPlatform.android),
      '127.0.0.1',
    );
    expect(
      emulatorHost(isWeb: false, platform: TargetPlatform.android),
      '10.0.2.2',
    );
  });

  group('initializeFirebase', () {
    late _RecordingGateway gateway;
    setUp(() => gateway = _RecordingGateway());

    test('routes every client to the emulators', () async {
      await initializeFirebase(
        gateway: gateway,
        environment: AppEnv.dev,
        useEmulators: true,
        isWeb: true,
        platform: TargetPlatform.android,
      );
      expect(gateway.calls, [
        'init:squad-manager-dev',
        'auth:127.0.0.1:9099',
        'firestore:127.0.0.1:8080',
        'storage:127.0.0.1:9199',
        'functions:europe-west3:127.0.0.1:5001',
      ]);
    });

    test('uses the Android emulator host on native Android', () async {
      await initializeFirebase(
        gateway: gateway,
        environment: AppEnv.dev,
        useEmulators: true,
        isWeb: false,
        platform: TargetPlatform.android,
      );
      expect(gateway.calls, contains('auth:10.0.2.2:9099'));
    });

    test('refuses prod with emulators before touching Firebase', () async {
      await expectLater(
        initializeFirebase(
          gateway: gateway,
          environment: AppEnv.prod,
          useEmulators: true,
          isWeb: true,
        ),
        throwsStateError,
      );
      expect(gateway.calls, isEmpty);
    });

    test('rejects unsupported native platforms', () async {
      await expectLater(
        initializeFirebase(
          gateway: gateway,
          environment: AppEnv.dev,
          useEmulators: false,
          isWeb: false,
          platform: TargetPlatform.iOS,
        ),
        throwsUnsupportedError,
      );
      expect(gateway.calls, isEmpty);
    });

    test('dev without emulators activates App Check debug provider', () async {
      await initializeFirebase(
        gateway: gateway,
        environment: AppEnv.dev,
        useEmulators: false,
        isWeb: true,
        webApiKey: 'test-key',
      );
      expect(gateway.calls, ['init:squad-manager-dev', 'appcheck']);
    });

    test('prod initializes the prod project only', () async {
      await initializeFirebase(
        gateway: gateway,
        environment: AppEnv.prod,
        useEmulators: false,
        isWeb: true,
        webApiKey: 'test-key',
      );
      expect(gateway.calls, ['init:squad-manager-de7c2']);
      expect(gateway.apiKeys, ['test-key']);
    });

    test(
      'uses a dummy API key for emulators when none is configured',
      () async {
        await initializeFirebase(
          gateway: gateway,
          environment: AppEnv.dev,
          useEmulators: true,
          isWeb: true,
          webApiKey: '',
        );
        expect(gateway.apiKeys, [emulatorApiKey]);
      },
    );

    test('fails fast without an API key outside the emulators', () async {
      await expectLater(
        initializeFirebase(
          gateway: gateway,
          environment: AppEnv.dev,
          useEmulators: false,
          isWeb: false,
          platform: TargetPlatform.android,
          androidApiKey: '',
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('firebase_keys_dev.json'),
          ),
        ),
      );
      expect(gateway.calls, isEmpty);
    });
  });
}

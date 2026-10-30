/// Build-time environment, set with `--dart-define`.
///
/// Example: `flutter run -d chrome --dart-define=ENV=dev --dart-define=USE_EMULATORS=true`
enum AppEnv {
  dev,
  prod;

  static AppEnv parse(String value) => switch (value) {
    'prod' => AppEnv.prod,
    _ => AppEnv.dev,
  };
}

abstract final class Env {
  static const String _envName = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static const bool useEmulators = bool.fromEnvironment('USE_EMULATORS');

  static AppEnv get current => AppEnv.parse(_envName);
}

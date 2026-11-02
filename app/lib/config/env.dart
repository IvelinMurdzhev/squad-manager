/// Build-time environment, set with `--dart-define`.
///
/// Example: `flutter run -d chrome --dart-define=ENV=dev --dart-define=USE_EMULATORS=true`
enum AppEnv {
  dev,
  prod;

  /// Rejects unknown names so a typo can never select the wrong project.
  static AppEnv parse(String value) => switch (value) {
    'dev' => AppEnv.dev,
    'prod' => AppEnv.prod,
    _ => throw ArgumentError.value(value, 'ENV', 'Expected "dev" or "prod"'),
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

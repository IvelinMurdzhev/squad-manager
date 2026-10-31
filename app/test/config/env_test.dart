import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/config/env.dart';

void main() {
  test('AppEnv.parse maps prod and defaults everything else to dev', () {
    expect(AppEnv.parse('prod'), AppEnv.prod);
    expect(AppEnv.parse('dev'), AppEnv.dev);
    expect(AppEnv.parse('anything'), AppEnv.dev);
  });

  test('Env defaults without dart-define', () {
    expect(Env.current, AppEnv.dev);
    expect(Env.useEmulators, isFalse);
  });
}

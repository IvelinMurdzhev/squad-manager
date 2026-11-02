import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/config/env.dart';

void main() {
  test('AppEnv.parse maps dev and prod and rejects anything else', () {
    expect(AppEnv.parse('prod'), AppEnv.prod);
    expect(AppEnv.parse('dev'), AppEnv.dev);
    expect(() => AppEnv.parse('production'), throwsArgumentError);
    expect(() => AppEnv.parse(''), throwsArgumentError);
  });

  test('Env defaults without dart-define', () {
    expect(Env.current, AppEnv.dev);
    expect(Env.useEmulators, isFalse);
  });
}

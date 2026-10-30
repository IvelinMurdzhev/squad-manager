import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/routing/auth_state.dart';
import 'package:squad_manager/routing/router.dart';

class _FakeAuth extends StubAuthState {
  _FakeAuth({this.signedIn = false, this.consent = false});

  final bool signedIn;
  final bool consent;

  @override
  bool get isSignedIn => signedIn;

  @override
  bool get hasConsent => consent;
}

void main() {
  group('redirectFor', () {
    test('signed out: public routes stay, others go to /welcome', () {
      final auth = _FakeAuth();
      for (final path in [
        '/welcome',
        '/sign-in',
        '/set-password',
        '/contact',
      ]) {
        expect(redirectFor(auth, path), isNull, reason: path);
      }
      for (final path in ['/hub', '/profile', '/admin', '/team/t1/match/m1']) {
        expect(redirectFor(auth, path), '/welcome', reason: path);
      }
    });

    test('signed in without consent: everything goes to /consent', () {
      final auth = _FakeAuth(signedIn: true);
      expect(redirectFor(auth, '/hub'), '/consent');
      expect(redirectFor(auth, '/consent'), isNull);
    });

    test('signed in with consent: entry screens go to /hub', () {
      final auth = _FakeAuth(signedIn: true, consent: true);
      expect(redirectFor(auth, '/welcome'), '/hub');
      expect(redirectFor(auth, '/sign-in'), '/hub');
      expect(redirectFor(auth, '/consent'), '/hub');
      expect(redirectFor(auth, '/profile'), isNull);
    });

    test('ignores query strings when matching', () {
      expect(redirectFor(_FakeAuth(), '/sign-in?mode=x'), isNull);
    });
  });
}

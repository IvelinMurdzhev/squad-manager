import 'package:flutter/foundation.dart';

/// What the router needs to know about the signed-in user.
///
/// Step 0.2 ships only [StubAuthState]. A Firebase-backed implementation
/// replaces it once auth is wired in (Phase 1).
abstract interface class AuthState implements Listenable {
  bool get isSignedIn;
  bool get hasConsent;
}

/// Always signed out. Used until real authentication exists.
class StubAuthState extends ChangeNotifier implements AuthState {
  @override
  bool get isSignedIn => false;

  @override
  bool get hasConsent => false;
}

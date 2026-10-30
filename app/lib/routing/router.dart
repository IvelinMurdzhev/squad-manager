import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../ui/core/placeholder_screen.dart';
import '../ui/welcome/welcome_screen.dart';
import 'auth_state.dart';

abstract final class AppRoutes {
  static const String welcome = '/welcome';
  static const String signIn = '/sign-in';
  static const String setPassword = '/set-password';
  static const String consent = '/consent';
  static const String contact = '/contact';
  static const String hub = '/hub';
  static const String matches = '/team/:teamId/comp/:compId/matches';
  static const String matchDetail = '/team/:teamId/match/:matchId';
  static const String lineup = '/team/:teamId/match/:matchId/lineup';
  static const String profile = '/profile';
  static const String org = '/org/:orgId';
  static const String admin = '/admin';

  /// Reachable while signed out.
  static const Set<String> public = {welcome, signIn, setPassword, contact};
}

/// Pure redirect rule, kept separate from [GoRouter] so it is easy to test.
String? redirectFor(AuthState auth, String location) {
  final path = Uri.parse(location).path;
  final isPublic = AppRoutes.public.contains(path);

  if (!auth.isSignedIn) {
    return isPublic ? null : AppRoutes.welcome;
  }
  if (!auth.hasConsent) {
    return path == AppRoutes.consent ? null : AppRoutes.consent;
  }
  if (path == AppRoutes.welcome ||
      path == AppRoutes.signIn ||
      path == AppRoutes.consent) {
    return AppRoutes.hub;
  }
  return null;
}

GoRouter createRouter(AuthState auth, {String? initialLocation}) {
  Widget placeholder(String Function(AppLocalizations) title) => Builder(
    builder: (context) {
      return PlaceholderScreen(title: title(AppLocalizations.of(context)));
    },
  );

  return GoRouter(
    initialLocation: initialLocation ?? AppRoutes.welcome,
    refreshListenable: auth,
    redirect: (context, state) => redirectFor(auth, state.uri.toString()),
    errorBuilder: (context, state) =>
        PlaceholderScreen(title: AppLocalizations.of(context).routeNotFound),
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => placeholder((l) => l.signIn),
      ),
      GoRoute(
        path: AppRoutes.setPassword,
        builder: (context, state) => placeholder((l) => l.setPasswordTitle),
      ),
      GoRoute(
        path: AppRoutes.consent,
        builder: (context, state) => placeholder((l) => l.consentTitle),
      ),
      GoRoute(
        path: AppRoutes.contact,
        builder: (context, state) => placeholder((l) => l.contacts),
      ),
      GoRoute(
        path: AppRoutes.hub,
        builder: (context, state) => placeholder((l) => l.teams),
      ),
      GoRoute(
        path: AppRoutes.matches,
        builder: (context, state) => placeholder((l) => l.matchesTitle),
      ),
      GoRoute(
        path: AppRoutes.matchDetail,
        builder: (context, state) => placeholder((l) => l.matchDetailTitle),
      ),
      GoRoute(
        path: AppRoutes.lineup,
        builder: (context, state) => placeholder((l) => l.lineupTitle),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => placeholder((l) => l.profile),
      ),
      GoRoute(
        path: AppRoutes.org,
        builder: (context, state) => placeholder((l) => l.organizationTitle),
      ),
      GoRoute(
        path: AppRoutes.admin,
        builder: (context, state) => placeholder((l) => l.adminTitle),
      ),
    ],
  );
}

---
name: squad-flutter-app
description: Squad Manager Flutter conventions covering folder structure, layered MVVM architecture, theme tokens from the spec, Bulgarian localization, go_router navigation, offline behaviour, PWA specifics and turning mockups into widgets. Use for any change under app/, including new screens, widgets, view models, repositories and routing.
---

When `.hq/` is available in the owner's working copy, use its referenced private material. On a public clone without `.hq/`, use tracked documentation and the user's request; if required product details or acceptance criteria are missing, ask before making a product decision.

# Squad Manager: Flutter app conventions

Complements the official skills `flutter-apply-architecture-best-practices`, `flutter-setup-declarative-routing` and `flutter-setup-localization`. Where they leave a choice open, this skill decides.

## Structure
```
app/lib/
  main.dart                 bootstrap: Firebase.initializeApp(options per ENV), App Check, emulators if USE_EMULATORS
  config/env.dart           ENV (dev|prod) and USE_EMULATORS from --dart-define
  config/theme/             tokens.dart (colors, radii, spacing), typography.dart, app_theme.dart
  routing/router.dart       go_router config, auth redirect, route names
  domain/models/            immutable models + fromJson/toJson
  data/services/            thin wrappers over Firebase SDKs (auth_service, firestore_service…)
  data/repositories/        app-facing API, streams, mapping, error handling
  ui/<feature>/             <feature>_screen.dart, <feature>_view_model.dart, widgets/
  ui/core/                  shared widgets (buttons, chips, crest, avatar, status pill)
  l10n/app_bg.arb           template ARB, Bulgarian
```
Features: `welcome`, `auth` (sign in, set password, consent), `hub`, `contact`, `team`, `competition`, `matches`, `match_detail`, `attendance`, `lineup`, `notifications`, `profile`, `stats`, `org_admin`, `platform_admin`.

## Architecture rules
- Views are dumb. A view model (`ChangeNotifier`) exposes state and commands. Repositories are injected with `provider`.
- Only `data/` imports Firebase packages. UI imports domain models and view models only.
- Real-time data = `Stream`s from repositories. Dispose subscriptions in view models.
- Model UI state as a sealed class (`Loading | Data | Empty | Error`), handled with an exhaustive `switch`.
- Errors: map Firebase exceptions to domain errors in repositories. Show localized messages. Report via Crashlytics on Android and the `logClientError` callable on web.

## Theme
Tokens mirror SPEC §5 exactly (`primary #1F5A3D`, `pitch #2F7A4A`, `gold #C9A43A`, `blue #2E5C8A`, `cream #F8F0E3`, `terracotta #B5502C`/`#9E4424`, `ink #2B2A25`, `inkMuted #6B655A`, `border #E2D3B8`, `divider #EADFCB`). Build `ThemeData` (Material 3) from them. Never write a hex value in a widget.
- Fonts are bundled as assets. Headings use a Cyrillic-capable condensed family (SPEC §5; Barlow Condensed lacks Cyrillic). Body text uses Manrope.
- Radii: card 16–18, button 14, chip stadium. Minimum touch target 44.

## From mockup to widget
1. Open `.hq/design/screens/NN-*.png`. Read exact values in `.hq/design/source/*.dc.html`.
2. Build with shared `ui/core` widgets first (CrestAvatar, StatusPill, CountdownChip, SegmentedChoice, PrimaryButton).
3. Strings go in ARB. Keys and Bulgarian copy are in `.hq/design/README.md`.
4. Add a widget test for each new screen (key states: loading, data, empty, error).
5. Check at 360×740 and 390×844, and in Chrome (PWA).

## Localization
`flutter gen-l10n` with `app_bg.arb` as the template and `bg` as the default locale. Use `intl` for dates in the Europe/Sofia zone, e.g. "Събота, 18 окт". Add plurals for counts ("след {n} дни").

## Offline and real time
Firestore persistence is on by default on mobile. Enable it explicitly on web where supported. Attendance writes must work offline (queued). Show a small "offline" banner when disconnected.

## PWA specifics
- `web/manifest.json`: name "Squad Manager", short_name "Squad Mgr", theme `#1F5A3D`, background `#F8F0E3`, icons 192/512 + maskable.
- FCM web needs `firebase-messaging-sw.js` and a VAPID key from config, not hard-coded secrets.
- On iOS, show an "Add to Home Screen" guide before asking for notification permission (iOS 16.4+).

## Navigation
go_router routes: `/welcome`, `/sign-in`, `/set-password`, `/consent`, `/contact`, `/hub`, `/team/:teamId/comp/:compId/matches`, `/team/:teamId/match/:matchId`, `/team/:teamId/match/:matchId/lineup`, `/profile`, `/org/:orgId`, `/admin`. Redirect rules: signed out → `/welcome`; no consent → `/consent`; no team → hub "no team" state.

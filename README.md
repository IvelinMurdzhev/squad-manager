# Squad Manager

An invite-only football club management app for matches, attendance, lineups, notifications and statistics. One Flutter app targets Android and the web. Firebase provides the backend services.

The project is in development. Public documentation describes the app and its architecture; detailed product planning and design references are maintained locally.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the app layers, Firebase boundaries, security model and test strategy.

## Quickstart

### Requirements

- Flutter stable and Dart 3
- Chrome for the web app
- Node.js LTS, Firebase CLI and JDK 21 when working with functions or Firebase emulators

This starter repository does not yet contain the Flutter scaffold. Once `app/` is created:

```sh
cd app
flutter pub get
flutter run -d chrome
```

After local Firebase emulator configuration is added, run the app with:

```sh
flutter run -d chrome --dart-define=ENV=dev --dart-define=USE_EMULATORS=true
```

Run app checks from `app/`:

```sh
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

When `functions/` and `rules-tests/` are available, use their documented npm scripts and Firebase emulator commands. Never point local development commands at production.

## Project guidance

`AGENTS.md` contains concise coding rules. Project-specific skills are in `.agents/skills/squad-*`; the public architecture and app code are sufficient to understand this submission without private planning notes.
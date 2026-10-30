---
name: squad-release
description: Build and ship Squad Manager, covering signed Android APK, web PWA build, deploys to the dev Firebase project, Firebase App Distribution, launcher and PWA icons from the logo, and release notes. Use when preparing a build, generating icons, or when the user asks to release, ship or distribute. Production deploys are human-only.
---

When `.hq/` is available in the owner's working copy, use its referenced private material. On a public clone without `.hq/`, use tracked documentation and the user's request; if required product details or acceptance criteria are missing, ask before making a product decision.

# Squad Manager: release

## Versioning
`app/pubspec.yaml` `version: MAJOR.MINOR.PATCH+BUILD`. Bump BUILD on every distributed build. Write release notes to `.hq/releases/<version>.md` (English, plus a short Bulgarian summary for players).

## Icons
Source: `.hq/design/logo/squad-manager-logo-1024.png` (transparent). Generate:
- Android adaptive icon: foreground = logo, background `#1F5A3D`. Check that the icon reads at 24 px.
- Web: `icons/Icon-192.png`, `Icon-512.png`, maskable variants with safe padding, `favicon.png`.
Use `flutter_launcher_icons` (dev dependency) or a script. Commit the generated icons.

## Android APK
- Signing: the keystore and `key.properties` live **outside the repo**. The human creates them once and keeps 2 backups. `android/app/build.gradle(.kts)` reads `key.properties` from a path given by env var or a local, git-ignored file.
- Build: `flutter build apk --release --dart-define=ENV=<dev|prod>`.
- Distribute to testers: `firebase appdistribution:distribute <apk> --app <android-app-id> --groups testers --release-notes-file <file> --project <project>`. Agents may do this for **dev only**, on human request.

## Web / PWA
- Build: `flutter build web --release --dart-define=ENV=<dev|prod>`.
- `firebase.json` hosting: `public: app/build/web`, SPA rewrite to `/index.html`. Cache headers: long for hashed assets, `no-cache` for `index.html`, `flutter_service_worker.js` and `firebase-messaging-sw.js`.
- Dev deploy (human request only): `firebase deploy --only hosting --project squad-manager-dev`.

## Production (human-only checklist)
1. Merge to `main` after required checks and approvals are complete.
2. Tag `vX.Y.Z`.
3. The human runs prod deploys for rules, indexes, functions and hosting, then builds and distributes the APK.
4. Smoke test: sign in, open a match, answer attendance, receive a push (Android and iPhone PWA).
5. Note the release in LOG.md.

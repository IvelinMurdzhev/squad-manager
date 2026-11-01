# Squad Manager

An invite-only football club management app for matches, attendance, lineups, notifications and statistics. One Flutter app targets Android and the web. Firebase provides the backend services.

The project is in development. Public documentation describes the app and its architecture; detailed product planning and design references are maintained locally.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the app layers, Firebase boundaries, security model and test strategy.

## Run locally

### Requirements

- Flutter stable and Dart 3
- Chrome for the web app
- Node.js 22, npm and JDK 21 for Functions and Firebase emulators
- Android SDK Platform 34 for the current Firestore plugin, plus the app's Flutter-selected compile SDK

Install dependencies from the repository root:

```sh
npm --prefix functions ci
npm --prefix rules-tests ci
npm --prefix functions run build
cd app
flutter pub get
```

Run Flutter commands below from `app/`.

From the repository root, start the full local suite with one command:

```sh
npx -y firebase-tools@15.34.2 emulators:start --project squad-manager-dev
```

This starts Auth (9099), Firestore (8080), Storage (9199), Functions (5001), Hosting (5000), and the [emulator UI](http://127.0.0.1:4000). Hosting serves `app/build/web`; build it first with the emulator flags below. The services bind to `127.0.0.1`. Emulator data is ephemeral.

In another terminal, from `app/`:

```sh
flutter run -d chrome --dart-define=ENV=dev --dart-define=USE_EMULATORS=true
```

If the local debugger websocket cannot connect, add `--release` to the Chrome command. This runs the same Firebase bootstrap without DWDS debugging.

For an Android virtual device, replace `chrome` with its ID from `flutter devices`. Bootstrap uses `10.0.2.2` on Android and `127.0.0.1` on web. Physical devices are outside this local-only setup. Android's debug build allows local HTTP traffic; release builds are not the emulator target.

The app configures Auth, Firestore, Storage and Functions (`europe-west3`) before showing the Welcome screen. Emulator runs disable persistent Firestore caching and skip App Check token exchange. Outside emulators, dev uses App Check debug providers; production attestation is deferred to step 1.5. Do not register or commit debug tokens.

To verify actual Flutter SDK requests against the running emulators:

```sh
flutter run -d chrome -t tool/emulator_smoke.dart --dart-define=ENV=dev --dart-define=USE_EMULATORS=true
```

It creates and deletes a fake anonymous Auth user and checks that server Firestore and Storage reads are denied. Success prints `Emulator smoke: PASS` and displays Welcome.

Build the emulator web app from `app/`:

```sh
flutter build web --dart-define=ENV=dev --dart-define=USE_EMULATORS=true
```

Then open [local Hosting](http://127.0.0.1:5000). The health endpoint is [local health](http://127.0.0.1:5001/squad-manager-dev/europe-west3/health): GET and HEAD return an empty 200 when Firestore read/write, Auth and Storage probes succeed, or an empty 503 on failure. Other methods return 405. Because the endpoint is public, results (including failures) are reused for 30 seconds per instance, so repeated requests do not repeat the backend probes. It writes only `system/health` through the Admin SDK; client rules deny all reads and writes. Scheduled-job freshness checks are deferred until scheduled jobs exist.

Run app checks from `app/`:

```sh
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Run backend checks from the repository root, with the interactive emulator suite stopped:

```sh
npm --prefix functions run lint
npm --prefix functions run build
npm --prefix functions test
npx -y firebase-tools@15.34.2 emulators:exec --project demo-squad-manager --only firestore,storage,auth "npm --prefix rules-tests test"
```

Rules tests use fake data and a demo project, and require emulator environment variables; they never fall back to cloud services. They cover anonymous, signed-in and admin-claim clients, including nested paths. The bootstrap rejects `ENV=prod` combined with `USE_EMULATORS=true`, and `ENV` accepts only `dev` or `prod`.

### Firebase environments and API keys

Aliases are `default`/`dev` → `squad-manager-dev` and `prod` → `squad-manager-de7c2`. Project, app and bucket IDs are committed in `app/lib/config/firebase_options.dart`. Android initializes with these Dart-selected options; no Google Services Gradle plugin or bundled `google-services.json` can silently choose another project.

The Web and Android API keys are public identifiers, not credentials, but they are kept out of git. Copy `app/firebase_keys.example.json` to `app/firebase_keys_dev.json` and `app/firebase_keys_prod.json` (both gitignored) and fill in the keys from the Firebase console (Project settings → Your apps). Pass the file for the environment you run, from `app/`:

```sh
flutter run -d chrome --dart-define=ENV=dev --dart-define-from-file=firebase_keys_dev.json
flutter build web --dart-define=ENV=prod --dart-define-from-file=firebase_keys_prod.json
```

Emulator runs (`USE_EMULATORS=true`) need no key file; a dummy key is used. Any other run without a key fails at startup with a clear error. Restrict each key in Google Cloud (Web: HTTP referrers; Android: package and SHA-1) and enforce App Check before production. Production builds and deploys are done by the owner.

On Windows, if Node-based tools fail certificate validation behind a managed proxy, use the system trust store in that terminal (`$env:NODE_USE_SYSTEM_CA = '1'`). Do not disable TLS verification.

## Project guidance

`AGENTS.md` contains concise coding rules. Project-specific skills are in `.agents/skills/squad-*`; the public architecture and app code are sufficient to understand this submission without private planning notes.

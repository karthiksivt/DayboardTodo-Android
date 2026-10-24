# Dayboard for Android + ChromeOS

This repository is the Flutter Android/Chromebook companion to the existing Dayboard macOS Electron app. It is offline-first, touch-friendly, and responsive to phone, tablet, and Chromebook window sizes.

## Implemented

- Neo-brutalist warm paper UI with black borders, hard shadows, and eight persisted note themes.
- Month calendar with selected-day agenda and task/time-block cards.
- Add/edit/delete items with current-time and current-time-plus-one-hour defaults.
- Completion checkboxes, scheduled start/end display, and preserved task colors.
- Full-screen notes focus mode with title/body editing, heading, bullet, and checklist blocks.
- Dedicated checklist and bullet lines: Enter creates a new block; empty-line Backspace removes the block.
- Local JSON state persisted through `shared_preferences`, with a version field ready for migrations.
- Attachments copied into the app documents directory and represented by durable metadata.
- URL validation for `http` and `https` links.
- Adaptive single-column / two-column layout for Android and ChromeOS.
- Android notification plugin initialized and ready for reminder scheduling integration.

## Local setup

Install Flutter 3.22 or newer, then run:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

For a Chromebook, enable Linux/Android development as appropriate, connect an Android target, and run the same commands. Resize the app window to verify the two-column breakpoint.

## Build artifacts

```bash
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release
```

Expected output paths:

- `build/app/outputs/flutter-apk/app-debug.apk`
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

The current development environment did not have the Flutter SDK installed, so these artifacts must be generated in a Flutter-enabled environment.

## Signing

Create a keystore outside this repository and never commit it or its passwords:

```bash
keytool -genkeypair -v -keystore ~/dayboard-upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias dayboard
```

Create `android/key.properties` locally with `storePassword`, `keyPassword`, `keyAlias`, and `storeFile`, then configure the release signing block in `android/app/build.gradle`. Keep `android/key.properties` and all keystores ignored by Git.

Google Play is the recommended update channel. If direct APK distribution is added later, use a visible release-page/download flow; Android apps cannot silently update like a signed Electron desktop app.

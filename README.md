# ARTISANAI

AI wallpapers, fresh every morning — 05:30 IST. One landscape, one portrait, one live wallpaper, every day. Cinematic teal-and-gold art, in the style of a daily art drop.

## Download

Every push to `main` builds the app on GitHub Actions (free). Download the latest build from the **Actions** tab, under Artifacts:

- **Android** — artifact `artisanai-app-debug` — `app-debug.apk` (about 142 MB, debug build for testing on your phone)
- **Windows 10 / 11** — artifact `artisanai-windows` — the Release folder, run `artisanai_wallpaper.exe` (Windows 10 or later; there is no Windows 9, Microsoft skipped it)

Latest run: https://github.com/rushh4196-create/artisanai-wallpaper/actions

## About the app

- Flutter, one codebase for Android + Windows
- Dark theme: deep teal `#072A30` + gold `#D4AF37`
- Today's Drop, Browse, Favourites (on-device, no accounts in the MVP)
- Phase 0: placeholder art only. Real daily drops arrive with the Phase 2 pipeline.

## Build it yourself

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug        # Android
flutter build windows --release  # Windows 10/11
```

Flutter 3.50.1, Dart 3.14.0, Java 17.

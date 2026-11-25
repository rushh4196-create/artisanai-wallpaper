# ARTISANAI — Free permanent cloud build (GitHub Actions)

## Why this exists
`flutter build apk --debug` on this VM fails at the Gradle daemon step:
the daemon starts on 127.0.0.1, then the launcher cannot connect to it,
even with Other TCP set to Ask and the approval granted. That is a
sandbox limit of this VM, not a problem in the app code — Flutter,
Android SDK, `flutter analyze` and `flutter test` all pass here.

So the APK is built in the cloud instead, on GitHub's runners, where
there is no such localhost restriction. This is the permanent build
route from now on — every push rebuilds the APK automatically.

## Cost
Free. Public repo on GitHub Actions: standard Linux runners are free.
No card, no subscription. The APK is kept as a workflow artifact for
90 days per build.

## What is already prepared (25 Nov 2026)
- `.github/workflows/build-apk.yml` — verified YAML. Uses Flutter
  3.50.1 (same as this VM), Java 17, `flutter pub get` → `flutter
  analyze` → `flutter test` → `flutter build apk --debug` → uploads
  `app-debug.apk` as artifact `artisanai-app-debug`.
- Local git repo initialised in `~/workspace/artisanai-wallpaper/`
  (not pushed yet — GitHub is not connected).
- No secrets, no signing keys in the repo. Debug APK only — no
  release signing yet (Phase 5 / Play Store step).

## One-time setup (Rdj, ~5 minutes)
1. Connect GitHub in Muse (the same connection needed for the
   rea-image repo). Then create a NEW PUBLIC repo, e.g. `artisanai-wallpaper`.
2. Push this project to it (from this VM, once connected):
   ```
   cd ~/workspace/artisanai-wallpaper
   git add .
   git commit -m "ARTISANAI Phase 0 + GitHub Actions APK build"
   git branch -M main
   git remote add origin https://github.com/<your-login>/artisanai-wallpaper.git
   git push -u origin main
   ```
3. On github.com, open the repo → Actions tab → the run starts
   automatically → when it is green, open the run → Artifacts →
   download `artisanai-app-debug` → install `app-debug.apk` on your
   phone (allow install from browser / Files once).

## Every build after that
Push any change to `main` (or press Run workflow in Actions) and a
fresh APK appears in Artifacts. No VM build, no Windows PC, no
localhost daemon needed.

## What this does NOT replace
- Windows `.exe` still needs a Windows build (`flutter build windows`)
  — that is a separate Phase 5 step, also doable later via a Windows
  runner if wanted.
- Release / Play Store signing is not in this workflow yet.

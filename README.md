# SteadyWeek

Flutter app for balanced weekly planning: routines, goals across life spheres, daily/weekly reports, XP cosmetics, local notifications.

Product spec: [`docs/MASTER_PLAN.md`](docs/MASTER_PLAN.md).

## Flutter app

- **Code:** [`life_balance/`](life_balance/)
- **Phase A** (current): shell navigation, English UI strings, Riverpod + go_router.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) stable **or** a clone under `tools/flutter` (see below).

### Optional: project-local Flutter (no admin install)

If `flutter` is not on your PATH, clone once:

```powershell
git clone https://github.com/flutter/flutter.git -b stable tools\flutter
$env:Path = ".\tools\flutter\bin;$env:Path"
flutter doctor
```

The folder `tools/flutter` is listed in `.gitignore` (large download).

### If `flutter` is “not recognized” (new PowerShell window)

Flutter from this repo lives in `tools\flutter\bin` and is **not** added to your user PATH by default.

**Option A — script (simplest):** from `life_balance` run any Flutter command like this:

```powershell
cd life_balance
.\flutter-dev.ps1 gen-l10n
.\flutter-dev.ps1 run -d chrome
```

**Option B — only this session:**

```powershell
$env:Path = "e:\PrProjects\Projtct\tools\flutter\bin;$env:Path"
cd life_balance
flutter gen-l10n
flutter run -d chrome
```

**Option C — permanently:** Windows → Environment Variables → User `Path` → add  
`e:\PrProjects\Projtct\tools\flutter\bin` (adjust drive if your project path differs).

### Run

```powershell
cd life_balance
.\flutter-dev.ps1 pub get
.\flutter-dev.ps1 gen-l10n
.\flutter-dev.ps1 run -d chrome
```

Use an attached Android device/emulator or iOS Simulator **on macOS**.

**Note:** Local daily reminders (21:00) run on **Android / iOS / desktop** builds only; **Chrome / web** skips `flutter_local_notifications` by design.

**Web + Drift:** the repo includes `life_balance/web/sqlite3.wasm` (sqlite3 **2.9.4**) and `drift_worker.js` (drift **2.31.0**). If you upgrade `drift` / `sqlite3` in `pubspec.lock`, replace these files from the matching [sqlite3.dart releases](https://github.com/simolus3/sqlite3.dart/releases) and [drift releases](https://github.com/simolus3/drift/releases).

### After editing `l10n/*.arb`

```powershell
cd life_balance
.\flutter-dev.ps1 gen-l10n
```

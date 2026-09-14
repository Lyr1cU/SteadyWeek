# SteadyWeek — React Native (Expo)

Rewrite of the Flutter client, same product spec: [`../../docs/MASTER_PLAN.md`](../../docs/MASTER_PLAN.md).

How the code is layered: [`../../docs/ARCHITECTURE.md`](../../docs/ARCHITECTURE.md).

Flutter reference stays in [`../../flutter-version/`](../../flutter-version/). Nest API is [`../backend/`](../backend/).

## Run (Expo Go — sync, Today, assistant)

```powershell
cd ReactNative-version\frontend
copy .env.example .env   # set EXPO_PUBLIC_API_URL to your PC LAN IP (not localhost)
npm start
```

Expo Go on a phone, or `w` for web. Same Wi‑Fi as PC. Backend on port 3000.

**Close-day notifications are not in Expo Go** — use the dev build below.

## Dev build (notifications + `expo-notifications`)

One-time install via USB or **Wi‑Fi ADB**: [`scripts/android-wifi-dev.md`](scripts/android-wifi-dev.md)

```powershell
cd ReactNative-version\frontend
npm run android:dev
```

Open the **SteadyWeek** dev app (not Expo Go). Keep `npm start` running for JS updates.

Profile → **Test notification (5 sec)** after allowing notifications.

## Now (Phase 3+)

- Shell tabs: Today, Week, Routine, Profile
- Today/Routine persist in **SQLite**; sync to Neon when signed in
- **Assistant** chat (templates offline; Groq via Nest when signed in + online)
- FAB ✦ on Today opens assistant
- Auth + sync status badge (offline / syncing / synced)
- Extra screens as placeholders: Close day, Shop, Weekly report
- Day/XP rules as **pure functions** in `src/logic/`

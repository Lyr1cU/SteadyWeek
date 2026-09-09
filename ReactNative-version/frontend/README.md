# SteadyWeek — React Native (Expo)

Rewrite of the Flutter client, same product spec: [`../../docs/MASTER_PLAN.md`](../../docs/MASTER_PLAN.md).

How the code is layered: [`../../docs/ARCHITECTURE.md`](../../docs/ARCHITECTURE.md).

Flutter reference stays in [`../../flutter-version/`](../../flutter-version/). Nest API is [`../backend/`](../backend/).

## Run

```powershell
cd ReactNative-version\frontend
copy .env.example .env   # set EXPO_PUBLIC_API_URL to your PC LAN IP (not localhost)
npm start
```

Then Expo Go on a phone, or `a` / `i` / `w` for Android / iOS / web.

Phone and PC must be on the same Wi‑Fi. Backend: [`../backend/`](../backend/) on port 3000.

## Now (Phase 3)

- Shell tabs: Today, Week, Routine, Profile
- Today/Routine persist in **SQLite**; sync to Neon when signed in
- **Assistant** chat (templates offline; Groq via Nest when signed in + online)
- FAB ✦ on Today opens assistant
- Auth + sync status badge (offline / syncing / synced)
- Extra screens as placeholders: Close day, Shop, Weekly report
- Day/XP rules as **pure functions** in `src/logic/`

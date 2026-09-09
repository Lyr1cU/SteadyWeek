# SteadyWeek

App for balanced weekly planning: routines, goals across life spheres, daily/weekly reports, XP cosmetics, local notifications.

Product spec: [`docs/MASTER_PLAN.md`](docs/MASTER_PLAN.md).  
**How we build now** (Nest, Neon Postgres, SQLite sync, phases): [`docs/DEV_PLAN.md`](docs/DEV_PLAN.md).  
Architecture (layers, data flow): [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## React Native (active)

- **Client:** [`ReactNative-version/frontend/`](ReactNative-version/frontend/)
- **API:** [`ReactNative-version/backend/`](ReactNative-version/backend/)
- Expo + TypeScript. Local-first SQLite; cloud sync via Nest + Neon (Phase 2+).

```powershell
cd ReactNative-version\frontend
npm install
npm start
```

Web (with SQLite): `npm run web`

```powershell
cd ReactNative-version\backend
npm install
npm run start:dev
```

Health check: `GET http://localhost:3000/health` → `{ "ok": true, "service": "steadyweek-api" }`

## Flutter app (reference only)

- **Code:** [`flutter-version/`](flutter-version/)
- UI and formula reference. Not the active rewrite — see [`docs/DEV_PLAN.md`](docs/DEV_PLAN.md).

```powershell
cd flutter-version
.\flutter-dev.ps1 pub get
.\flutter-dev.ps1 run -d chrome
```

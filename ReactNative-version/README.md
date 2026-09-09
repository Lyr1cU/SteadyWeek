# React Native stack

Active client + API. Flutter archive is [`../flutter-version/`](../flutter-version/).

| Folder | Role |
|--------|------|
| [`frontend/`](frontend/) | Expo / React Native + SQLite sync |
| [`backend/`](backend/) | NestJS + Prisma + Neon Postgres |

## Frontend

```powershell
cd frontend
copy .env.example .env   # EXPO_PUBLIC_API_URL = your PC IP :3000 for Expo Go
npm install
npm start
```

## Backend

See [`backend/README.md`](backend/README.md) — Neon `DATABASE_URL`, `npm run prisma:deploy`, `npm run start:dev`.

## Phase 2 sync flow

1. Run backend with Neon migrated.
2. In app: Profile → Sign in (register once).
3. Edit routine on web or phone → tap **Synced** badge or wait for network reconnect.
4. Other device pulls changes after login + sync.

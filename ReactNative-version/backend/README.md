# Backend (Nest + Prisma 7 + Neon)

```powershell
cd backend
copy .env.example .env   # set DATABASE_URL (Neon) and JWT_SECRET
npm install              # runs prisma generate via postinstall
npm run prisma:deploy    # applies migrations to Neon
npm run start:dev
```

Connection URL lives in `.env` and `prisma.config.ts` (not in `schema.prisma`).

Health: `GET http://localhost:3000/health`

Auth: `POST /auth/register`, `POST /auth/login` → `{ accessToken, user }`

Sync (JWT): `GET /sync/pull?since=ISO`, `POST /sync/push`

Deletes are **soft**: rows stay in Postgres with `deleted_at` set (hidden in the app and in `GET /routine`). In Neon SQL use `WHERE deleted_at IS NULL` to list active items only.

Routine: `GET /routine` · Day state: `GET /day-state?dayKey=yyyy-MM-dd`

Assistant (JWT): `POST /assistant/chat` body `{ message, dayKey? }` → `{ reply, source: 'groq' | 'template' }`

Optional in `.env`: `GROQ_API_KEY`, `GROQ_MODEL` (default `openai/gpt-oss-20b`), `ASSISTANT_RATE_LIMIT_PER_MIN` (default 10). Without Groq key the API returns templates from today's routine context.

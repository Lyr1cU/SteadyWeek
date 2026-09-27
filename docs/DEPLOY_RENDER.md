# Deploy SteadyWeek API on Render (Free)

Neon stays your database. Render runs only the **Nest** backend.

## 1. Push Blueprint

Ensure `render.yaml` is on `main` in GitHub:

```powershell
git add render.yaml docs/DEPLOY_RENDER.md
git commit -m "Add Render Blueprint for Nest API"
git push origin main
```

## 2. Create service from Blueprint

Open (logged into Render):

[Create Blueprint from repo](https://dashboard.render.com/blueprint/new?repo=https://github.com/Lyr1cU/SteadyWeek)

1. Connect GitHub if asked → select **SteadyWeek**.
2. Review **steadyweek-api** (Free, Frankfurt, `ReactNative-version/backend`).
3. **Environment variables** (required before first successful deploy):
   - **`DATABASE_URL`** — Neon connection string (`?sslmode=require`), same as local backend `.env`. **Required at runtime** for `prisma migrate deploy` and the API (build can proceed without it after `prisma.config.ts` placeholder fix).
   - **`JWT_SECRET`** — long random string (Render can generate).
   - **`GROQ_API_KEY`** — optional; leave empty for template-only assistant.
4. Click **Apply** → wait for build + `preDeployCommand` (`prisma migrate deploy`).

Public URL: **https://steadyweek-api.onrender.com**  
Dashboard: https://dashboard.render.com/web/srv-dasnueo473hc73962b7g

If build fails with `Cannot resolve environment variable: DATABASE_URL` on an older commit, pull latest `main` (placeholder in `prisma.config.ts`) **and** set `DATABASE_URL` in Environment for runtime.

Connect **GitHub** to Render (Settings → Git) if logs say repo access warnings.

## 3. Verify

```text
GET https://<your-service>.onrender.com/health
→ {"ok":true,"service":"steadyweek-api"}
```

First request after ~15 min idle may take **30–50 s** (Free tier sleep).

## 4. Phone + MCP

**Frontend** (`ReactNative-version/frontend/.env`):

```env
EXPO_PUBLIC_API_URL=https://steadyweek-api.onrender.com
```

Rebuild **release APK** (URL is baked in at build time).

**MCP** (`steadyweek` in Cursor `mcp.json`):

```json
"STEADYWEEK_API_URL": "https://steadyweek-api.onrender.com"
```

## 5. Notes

- **Do not** use Render Free Postgres for prod — you already use **Neon**; only set `DATABASE_URL`.
- **HTTPS** — no `usesCleartextTraffic` needed on Android for production API.
- **Register/login** on a new JWT secret: if you change `JWT_SECRET`, sign in again on all clients.
- **Logs**: Render Dashboard → steadyweek-api → Logs.

## Manual deploy (without Blueprint)

Dashboard → New → Web Service → repo `Lyr1cU/SteadyWeek`, root directory `ReactNative-version/backend`, build:

```bash
npm ci --include=dev && npm run build && npm prune --omit=dev
```

start `npm run start:prod` (or migrate in start: `npx prisma migrate deploy && npm run start:prod`), add env vars above, plan **Free**, health check `/health`.

**If `nest: not found`:** Render sets `NODE_ENV=production`, so `npm ci` skips devDependencies. Use `--include=dev` in the build command (see above).

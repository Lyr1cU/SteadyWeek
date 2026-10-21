# Фаза 7 — отчёт (Prod API + расширенный MCP)

Дата: 2026-09-27  
Статус: **Render API live**; MCP расширен; клиент/MCP config — частично

См. [`docs/DEV_PLAN.md`](../DEV_PLAN.md) §10.

---

## Цель

- Nest на **Render Free** (HTTPS), Neon как БД.
- MCP в Cursor: не только рутина, но и статусы дня, цели недели, close day, stats, sync nudge.
- UI polish (§9) закрыт отдельно в DEV_PLAN.

---

## Render

| | |
|---|---|
| URL | https://steadyweek-api.onrender.com |
| Health | `GET /health` |
| Dashboard | см. Render → `steadyweek-api` |
| Доки | [`docs/DEPLOY_RENDER.md`](../DEPLOY_RENDER.md) |
| Blueprint | `render.yaml` (root) |

Build: `npm ci --include=dev && npm run build && npm prune --omit=dev` (из‑за `NODE_ENV=production`).

---

## Новые Nest endpoints (JWT)

| Метод | Путь |
|-------|------|
| POST | `/day-state/status` |
| GET/POST | `/weekly-goals`, `/weekly-goals/upsert` |
| GET | `/insights/user-stats`, `/insights/daily-report`, `/insights/weekly-report` |
| POST | `/close-day` |
| GET/POST | `/sync/revision`, `/sync/nudge` |

---

## steadyweek-mcp (v0.2.x)

Полный список tools — [`steadyweek-mcp/README.md`](../../steadyweek-mcp/README.md).

Cursor: `STEADYWEEK_API_URL=https://steadyweek-api.onrender.com` + email/password.

**Не сделано:** remote MCP (Streamable HTTP) для Claude.ai / mobile.

---

## Клиент

- MCP nudge: `frontend/src/data/sync/mcp-sync-nudge.ts` + `sync-context`
- [ ] Release APK с production `EXPO_PUBLIC_API_URL`

---

## Чеклист

- [x] Render deploy successful
- [x] `/health` 200
- [x] MCP smoke (Cursor): upsert, status, goal, close_day
- [ ] Phone release на Render URL
- [ ] Cursor mcp.json на HTTPS (у пользователя локально)

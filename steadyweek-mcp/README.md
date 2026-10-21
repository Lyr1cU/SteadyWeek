# steadyweek-mcp

MCP server for **SteadyWeek** — calls the Nest API (JWT), not Neon directly.

## Tools

| Tool | Nest API |
|------|----------|
| `get_today` | `GET /schedule/day?dayKey=` (+ `_meta.timezoneUsed`) |
| `get_day` | `GET /schedule/day?dayKey=` |
| `get_week_schedule` | `GET /schedule/week?startDayKey=` |
| `list_routine_items` | `GET /routine` |
| `upsert_routine_item` | `POST /routine/upsert` |
| `set_day_item_status` | `POST /day-state/status` |
| `list_weekly_goals` | `GET /weekly-goals?weekKey=` |
| `upsert_weekly_goal` | `POST /weekly-goals/upsert` |
| `get_user_stats` | `GET /insights/user-stats` |
| `get_daily_report` | `GET /insights/daily-report?dayKey=` |
| `close_day` | `POST /close-day` |
| `get_weekly_report` | `GET /insights/weekly-report?weekKey=` |
| `get_cloud_revision` | `GET /sync/revision` |
| `request_client_sync_nudge` | `POST /sync/nudge` |
| `wait_for_cloud_revision` | polls `GET /sync/revision` |

After cloud writes, the phone picks up on **auto-sync** (~45s while the app is open), **`request_client_sync_nudge`** (extra quiet pull when the nudge setting changes), returning to the foreground, or **Sync now**.

### Weekdays bitmask

Mon=1, Tue=2, Wed=4, Thu=8, Fri=16, Sat=32, Sun=64 — **sum** the days (e.g. Mon–Fri = **31**, every day = **127**).

### Timezone

Optional `STEADYWEEK_TIMEZONE` (IANA, e.g. `Europe/Kyiv`) controls the default day for `get_today` / `get_week_schedule` when `dayKey` is omitted. Without it, the **host OS** local date is used (may differ from the phone).

### Weekly goals

`weekKey` is **Monday** `yyyy-MM-dd` (same as the app Week screen). Tools accept any day in the week and normalize to Monday.

Spheres: `work`, `body`, `social`, `rest`, `home`, `growth`. Soft-delete goals/routine: `id` + `delete: true`.

## Setup

```powershell
cd steadyweek-mcp
npm install
npm run build
```

Environment (do **not** commit real passwords):

| Variable | Example |
|----------|---------|
| `STEADYWEEK_API_URL` | `http://127.0.0.1:3000` or your LAN URL |
| `STEADYWEEK_EMAIL` | your app login |
| `STEADYWEEK_PASSWORD` | your app password |
| `STEADYWEEK_TIMEZONE` | optional, e.g. `Europe/Kyiv` |

## Cursor MCP config

Add `steadyweek` in user `mcp.json`. Template: `.cursor/mcp.json.example`.

Run `npm run build` after pulling changes. Backend must be up (`npm run start:dev` in `ReactNative-version/backend`).

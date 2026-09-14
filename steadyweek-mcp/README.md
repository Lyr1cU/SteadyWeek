# steadyweek-mcp

MCP server for **SteadyWeek** — calls the Nest API (JWT), not Neon directly.

## Tools

| Tool | Nest API |
|------|----------|
| `get_today` | `GET /schedule/day?dayKey=` (default: local today) |
| `get_day` | `GET /schedule/day?dayKey=` |
| `get_week_schedule` | `GET /schedule/week?startDayKey=` |
| `upsert_routine_item` | `POST /routine/upsert` |

After `upsert_routine_item`, the phone picks it up on **auto-sync** (~45s while the app is open) or immediately on **Sync now** / returning to the foreground.

Spheres must match the app: `work`, `body`, `social`, `rest`, `home`, `growth` (not `health` / `creative`). Soft-delete: `id` + `delete: true` (title/sphere not required).

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

## Cursor MCP config

Cursor reads **user-level** `C:\Users\<you>\.cursor\mcp.json` for all workspaces (alongside any project `.cursor/mcp.json`). Add `steadyweek` next to your other servers. **Never commit** real passwords; repo `.cursor/mcp.json` is gitignored — use `.cursor/mcp.json.example` only.

Template (credentials — same as Profile → Sign in; do not commit):

```json
"steadyweek": {
  "command": "node",
  "args": ["E:/PrProjects/SteadyWeek/steadyweek-mcp/dist/index.js"],
  "env": {
    "STEADYWEEK_API_URL": "http://127.0.0.1:3000",
    "STEADYWEEK_EMAIL": "you@example.com",
    "STEADYWEEK_PASSWORD": "your-app-password"
  }
}
```

Project copy (gitignored): copy `.cursor/mcp.json.example` → `.cursor/mcp.json` if you prefer repo-local docs only.

Run `npm run build` after pulling changes. Backend must be up (`npm run start:dev` in `ReactNative-version/backend`).

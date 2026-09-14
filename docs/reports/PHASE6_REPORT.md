# Фаза 6 — отчёт (MCP, уведомления, полировка)

Дата: 2026-09-14 — 2026-09-15  
Статус: **реализовано и проверено** (MCP end-to-end, auto-sync)

См. [`docs/DEV_PLAN.md`](../DEV_PLAN.md) §8.

---

## Цель фазы

- Управление расписанием из **Cursor** через Nest API (JWT), без прямого Neon из MCP.
- Локальное напоминание «закрыть день», каркас **l10n EN**.
- Визуальная полировка **Today** (nebula + glass-карточки как во Flutter `ChromeCard`).
- Dev-сборка Android для notifications и Wi‑Fi ADB.

---

## Nest API (schedule + routine upsert)

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/schedule/today` | Пункты на «сегодня» (TZ сервера) |
| GET | `/schedule/day?dayKey=` | Любой день `YYYY-MM-DD` |
| GET | `/schedule/week?startDayKey=` | Пн–Вс недели, содержащей дату |
| POST | `/routine/upsert` | Создать / обновить / soft-delete пункт |

Все с **JWT**, как sync. Данные = Neon (рутина + day status).

**Код:** `ReactNative-version/backend/src/schedule/`, `routine/routine.service.ts` (upsert).

---

## steadyweek-mcp

Папка: [`steadyweek-mcp/`](../../steadyweek-mcp/)

| Tool | API |
|------|-----|
| `get_today` | `GET /schedule/day?dayKey=` (default: local today) |
| `get_day` | `GET /schedule/day?dayKey=` |
| `get_week_schedule` | `GET /schedule/week?startDayKey=` |
| `upsert_routine_item` | `POST /routine/upsert` |

- Transport: **stdio**, `@modelcontextprotocol/sdk`
- Env: `STEADYWEEK_API_URL`, `STEADYWEEK_EMAIL`, `STEADYWEEK_PASSWORD`
- Сборка: `npm install` → `npm run build` → `node dist/index.js`

### Конфиг Cursor

- **User-level:** `C:\Users\<you>\.cursor\mcp.json` — рядом с Roblox / stitch (сервер `steadyweek`).
- **Шаблон в репо:** `.cursor/mcp.json.example` (локальный `.cursor/mcp.json` в **`.gitignore`**).

Backend на `http://127.0.0.1:3000` (или LAN IP ПК для телефона).

### Проверка (2026-09-15)

- Login + `get_today` / `upsert_routine_item` — OK.
- Создан тестовый пункт → правки title / time / sphere / effort через MCP — OK.
- На телефоне изменения видны после **pull** с облака (см. auto-sync ниже).

---

## Клиент (Expo RN)

### Sync с облаком (после MCP)

Раньше: только **Sync now** / sync после локальных правок.

**Сейчас** (`frontend/src/app/sync-context.tsx`):

- Каждые **45 с**, пока приложение **active** и пользователь залогинен — тихий `runSync()` (`quiet`, без мигания «Syncing…»).
- При возврате из **background** — полный sync.
- Как раньше: NetInfo online, sync после SQLite writes (`schedule-sync`), кнопка на badge.

Критерий DEV_PLAN: изменение из Cursor → на телефоне **без обязательного** нажатия Sync (до ~45 с или сразу при foreground).

### Today UI (макап Flutter)

- `today-item.tsx` — время слева (`formatTime12h`), glass-карточка, символ сферы, чекбокс, ⋮ skip.
- `today-weekly-goals-card.tsx` — блок Weekly goals.
- `today-date-bar.tsx`, `today-screen.tsx`, `main-shell.tsx`.
- `ui/sphere-ui.ts` — подписи сфер + **символы** (без `@expo/vector-icons` на карточках).
- `ui/glass-surface.tsx` — градиент + обводка как Flutter **`ChromeCard`**; padding только **внутри** градиента (fix «серой коробки» у Weekly goals).

### Metro / `@expo/vector-icons`

- На Windows Metro не резолвил `./ensure-native-module-available` в `@expo/vector-icons` → карточки переведены на **Text-символы**; пакет может оставаться для будущего.
- `frontend/metro.config.js` — workaround `.js` для relative imports в `@expo/vector-icons` (export/bundle).
- Исправлены импорты в `today-weekly-goals-card.tsx` (`../../ui/glass-surface`, `theme`).

### Assistant

- `use-assistant-chat.ts` — при fallback на Template показывается причина (offline, 401, ApiError).

### Уведомления

- `frontend/src/notifications/close-day-reminder.ts` — daily **21:00**, канал Android `close_day`.
- **Expo Go Android** — init пропускается (SDK 53+); реальные push только **dev build** (`expo-dev-client`).
- Profile: **Test notification (5 sec)** в dev build.

### l10n

- `frontend/src/l10n/en.ts` + `index.ts` — sync, assistant, notifications.

### Dev Android

- `expo-dev-client`, `npm run android:dev` (`--no-bundler`), Metro `expo start --dev-client --lan`.
- Скрипты: `frontend/scripts/android-dev.ps1`, `adb-env.ps1`, `android-wifi-dev.md`, firewall helper.
- `.env`: `EXPO_PUBLIC_API_URL=http://<PC_LAN>:3000`

### Прочее UI

- `ui/app-background.tsx` — nebula JPG + gradient.
- `ui/sync-status-badge.tsx` — tap = manual sync.
- `app.json` — plugins notifications, adaptive icon.

### Assistant (Groq в приложении)

- Контекст дня = **выбранная дата на Today** (стрелки календаря), не только «сегодня»; в шапке чата: `Day context: yyyy-MM-dd`.
- С Profile по-прежнему открывается без `dayKey` → календарное сегодня.
- Прошлые/будущие недели с телефона — через sync + локальная SQLite; MCP по-прежнему для Cursor.

---

## Доработки после ревью (2026-09-15)

- Удалены debug `#region agent log` (ingest + `debug-025fbd.log`) из `schedule.service.ts`, `routine.service.ts`, `steadyweek-mcp/src/api.ts`; `npm run build` в MCP.
- `.gitignore`: `.cursor/mcp.json`, `debug-025fbd.log` — пароли только локально, не в git.
- Smoke `get_week_schedule` с `startDayKey=2026-09-01` → `weekStart` **2026-08-31**, 7 дней — OK.

---

## Чеклист (ручная проверка)

- [x] Cursor MCP: env + `get_today` / `upsert_routine_item` → Neon
- [x] Телефон: изменения с MCP после auto-sync (или Sync now)
- [x] Today: glass-карточки + Weekly goals в том же стиле
- [x] Assistant: FAB с другого дня на Today → Groq/template с тем же `dayKey`
- [x] `get_week_schedule` для другой недели (smoke через MCP)
- [ ] Android dev build: permission → напоминание 21:00 (или test 5 sec на Profile)

---

## Ключевые пути

| Область | Путь |
|---------|------|
| MCP server | `steadyweek-mcp/src/index.ts`, `README.md` |
| MCP Cursor example | `.cursor/mcp.json.example` |
| Schedule API | `backend/src/schedule/` |
| Routine upsert | `backend/src/routine/` |
| Auto-sync | `frontend/src/app/sync-context.tsx` |
| Close-day notif | `frontend/src/notifications/close-day-reminder.ts` |
| l10n EN | `frontend/src/l10n/` |
| Glass UI | `frontend/src/ui/glass-surface.tsx` |
| Today | `frontend/src/features/today/` |
| Metro fix | `frontend/metro.config.js` |
| Android dev | `frontend/scripts/` |

---

## Не делали / позже

- Полный **uk** l10n и онбординг Stitch
- Серверный **FCM** push
- Store listing / скриншоты
- Фазы **4–5** (weekly goals в продукте, close day, XP, shop) — см. DEV_PLAN §6–7

---

## Заметки для следующей сессии

- Тестовый пункт MCP можно удалить: `upsert_routine_item` с `id` + `delete: true` или в Routine на телефоне.
- Интервал auto-sync **45 s** — при желании уменьшить в `AUTO_SYNC_INTERVAL_MS` в `sync-context.tsx`.
- MCP credentials только в user `mcp.json`, не коммитить.

---

## Правки после ревью (2026-09-15)

Runtime-проверка Nest:

- `POST /routine/upsert` с `sphere: health`, `effort: banana` раньше был **201** (клиентский `mapRoutineRow` после pull падал бы). Теперь **400**.
- Soft-delete требовал dummy `title`/`sphere`/`weekdays`. Теперь достаточно `id` + `delete: true`.
- `GET /schedule/week` больше не делает 7 полных `getDay` (N+1): одна выборка рутины + статусы недели.

Также: MCP-схема сфер = `work|body|social|rest|home|growth` (описание больше не предлагает `health`/`creative`); 401 retry в MCP ограничен одним разом; Today не падает из‑за одной битой строки SQLite.

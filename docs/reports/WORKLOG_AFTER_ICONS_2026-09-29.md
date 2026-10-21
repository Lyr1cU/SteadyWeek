# Worklog: после иконок → prod, polish, багфиксы, напоминания рутины

**Период (работа в чатах / локально):** примерно **2026-09-14 … 2026-09-29**  
**Точка отсчёта:** обновление **иконок и брендинга** в Expo (`app.json`, adaptive icon, splash, notification icon, assets).  
**Статус на конец периода:** приложение на **release APK** с **Render API**; §9 UI polish закрыт; §10 частично; MCP **отложен** до paid Render; post-icon фиксы **в рабочей копии** (часть ещё не в отдельном git commit).

См. также: [`PHASE6_REPORT.md`](./PHASE6_REPORT.md), [`PHASE7_REPORT.md`](./PHASE7_REPORT.md), [`DEV_PLAN.md`](../DEV_PLAN.md) §9–§12.

---

## 1. Старт: иконки и визуальная идентичность

### Что сделали

- Обновлены **assets** под SteadyWeek / Stitch-референс:
  - `icon.png`, `app_icon.png`, `favicon.png`, `splash-icon.png`
  - **Android adaptive icon:** `android-icon-foreground.png`, `android-icon-background.png`, `android-icon-monochrome.png`
  - **`notification-icon.png`** для канала Android (expo-notifications plugin)
- **`app.json`:** `name: SteadyWeek`, slug, adaptive icon `#0C0C12`, plugin `expo-notifications` с icon/color `#CAB8FF`.

### Зачем

- Единый вид на домашнем экране и в шторке уведомлений.
- Подготовка к store listing (не сделан, но assets готовы).

### Ограничения

- **Expo Go** на Android не показывает кастомные notification icons так же, как **dev/release** build.

---

## 2. Полировка UI (DEV_PLAN §9) — «ощущение продукта»

Цель: не новые фичи, а **motion + chrome + модалки**, как Flutter/Stitch.

### 2.1 Motion (Reanimated)

| Область | Реализация |
|--------|------------|
| Табы | `TabCrossfade`, лёгкий press на таббаре |
| Навигация | Directional slide между shell и pushed routes |
| Списки | `StaggerFadeIn` на Today, Week, Routine, Profile, Close day, Weekly report |
| Кнопки | `AnimatedPressable` на primary CTA и pills |
| Context menu | Reanimated enter/exit в `chrome-context-menu.tsx` |
| Close day | Mood stars, tier feedback |
| Reduce motion | `use-reduce-motion.ts`, `motion/constants.ts` |

### 2.2 Bottom sheets вместо «голых» модалок

- **`ChromeBottomSheet`:** slide-up backdrop + sheet (Reanimated), keyboard inset.
- **Routine:** `routine-editor-modal.tsx` → sheet + `RoutineFormFields`.
- **Week:** goal editor → тот же паттерн.

### 2.3 Контролы Today / Routine

- **`TodayTaskCheckbox`** — чекбокс с анимацией на Today.
- **Optional item** в редакторе рутины — тот же чекбокс, не пустой квадрат.
- **`RoutineTimeField`** — время в редакторе (DateTimePicker / web fallback).
- **GlassSurface**, nebula background, типографика профиля в духе Today/Week.

### 2.4 Статус в DEV_PLAN

§9 помечен **закрытым (2026-09-27)** — все пункты Scope `[x]`.

---

## 3. Фаза 7: production API на Render + расширение backend/MCP

### 3.1 Render (Free tier)

| | |
|---|---|
| Сервис | `steadyweek-api`, регион Frankfurt |
| URL | `https://steadyweek-api.onrender.com` |
| Health | `GET /health` → `{"ok":true,"service":"steadyweek-api"}` |
| Конфиг | `render.yaml` (root), [`DEPLOY_RENDER.md`](../DEPLOY_RENDER.md) |
| БД | Neon Postgres (тот же стек, что локальный backend) |

**Проблемы деплоя и фиксы:**

1. **`prisma generate` на build** без `DATABASE_URL` → placeholder в `prisma.config.ts`.
2. **`nest: not found`** при `NODE_ENV=production` → build:  
   `npm ci --include=dev && npm run build && npm prune --omit=dev`.
3. Env в Dashboard: `DATABASE_URL`, `JWT_SECRET` **без кавычек**.

**Огранение Free:** сервис **засыпает** (~15 min idle) → первый запрос 10–30+ с; для daily use — **Sync now** или терпеть cold start.

### 3.2 Новые Nest-модули / endpoints (JWT)

| Область | Endpoints |
|---------|-----------|
| Day status | `POST /day-state/status` |
| Weekly goals | `GET/POST /weekly-goals`, `/weekly-goals/upsert` |
| Insights | `GET /insights/user-stats`, `daily-report`, `weekly-report` |
| Close day | `POST /close-day` (логика tier/XP/streak как на клиенте) |
| Sync / MCP | `GET /sync/revision`, `POST /sync/nudge` (setting `steadyweek_mcp_nudge`) |

Код: `backend/src/close-day/`, `weekly-goals/`, `insights/`, расширения `day-state/`, `sync/`, `common/day-status-fields.ts`, `common/mcp-constants.ts`.

### 3.3 steadyweek-mcp (v0.2.x)

Расширенный набор tools (см. [`steadyweek-mcp/README.md`](../../steadyweek-mcp/README.md)):

- Routine: `list_routine_items`, `upsert_routine_item`, `sortOrder`
- День: `set_day_item_status`, `get_day`, `get_today`, `get_week_schedule`
- Цели: `list_weekly_goals`, `upsert_weekly_goal`
- Close day / отчёты: `close_day`, `get_daily_report`, `get_weekly_report`, `get_user_stats`
- Sync: `get_cloud_revision`, `request_client_sync_nudge`, `wait_for_cloud_revision`
- Env: `STEADYWEEK_TIMEZONE` (IANA) для «today» без dayKey

Smoke через Cursor + локальный/Render API: upsert, status, goal, close day — проверялось.

### 3.4 Клиент: sync и MCP nudge

- **`mcp-sync-nudge.ts`** — при изменении cloud setting `steadyweek_mcp_nudge` клиент делает **extra quiet pull**.
- **`sync-context.tsx`** — auto-sync ~45 s, foreground, NetInfo; подписка на nudge.
- **`apply-pull.ts`** — применение pull включая nudge setting.

### 3.5 Документация плана

- **`DEV_PLAN.md`:** слой 8, §10 Фаза 7, §9 закрыт, §11 repo tree + `steadyweek-mcp/`, §12 «что дальше».
- **`PHASE7_REPORT.md`** — краткий чеклист фазы.

---

## 4. Телефон, сборки, окружение

### 4.1 Release APK

- Сборка: `expo run:android --variant release` (JAVA_HOME Android Studio JBR, `GRADLE_USER_HOME` user).
- **`EXPO_PUBLIC_API_URL`:** переключали на `https://steadyweek-api.onrender.com` в `frontend/.env` для release bundle.
- Установка: USB A52 и Wi‑Fi adb (pair/connect) на A57 (`192.168.31.181`).
- APK path: `frontend/android/app/build/outputs/apk/release/app-release.apk`.

**Примечание:** release всё ещё содержит **expo-dev-client** plugin — открытие через dev URL не нужно; запуск с иконки.

### 4.2 Web для проверки UI

- `npx expo start --web --port 8082` → `http://localhost:8082` (API из `.env`, Render).

### 4.3 Wi‑Fi debugging (Samsung)

- **Auto Blocker** блокировал USB/Wi‑Fi debugging — выключить в Security.
- Pairing code + `adb pair` / `adb connect`.

---

## 5. MCP: как пользоваться и почему «не работает» в облачном чате

### Локальный Cursor

- `~/.cursor/mcp.json` → `steadyweek`, stdio → `steadyweek-mcp/dist/index.js`.
- Нужны `STEADYWEEK_EMAIL`, `STEADYWEEK_PASSWORD`, **`STEADYWEEK_API_URL`** (localhost vs Render).

### Типичная путаница

| Симптом | Причина |
|---------|---------|
| MCP зелёный, телефон не меняется | MCP на **localhost**, телефон на **Render** (разные инстансы/данные) |
| Облачный Agent: namespace not found | **stdio MCP не пробрасывается** в Cloud Agent — только hosted MCP (Firebase, Vercel, …) |
| Render «тормозит» | Cold start Free tier |

### Решение пользователя (конец периода)

**MCP в работе отложен** до **paid Render** (без sleep) — код в репо остаётся, в daily flow не опираемся.

**Remote MCP** (HTTP + auth для Claude mobile / cloud) — не реализован, в §10 как future.

---

## 6. Багфиксы после polish

### 6.1 Bottom sheet «реанимировался» при каждом вводе

**Симптом:** Edit routine / goal — каждая буква или chip → sheet снова slide-up.

**Причина:** `Easing.out/in` создавались **на каждом render** → менялся `playEnter` → `useEffect` заново вызывал enter animation.

**Фикс:** `MODAL_EASE_OUT/IN` на уровне модуля в `chrome-bottom-sheet.tsx` и `chrome-context-menu.tsx`.

### 6.2 Today: странный порядок пунктов

**Симптом:** время на карточках не по хронологии (6 PM, 4 PM, 1 AM, 11 AM…).

**Причина:** список шёл по **`sort_order`** (порядок создания), не по **`scheduledMinuteOfDay`**.

**Фикс:** `compareRoutineSchedule` как во Flutter — `frontend/src/logic/routine-schedule.ts`; сортировка в `loadTodayRows`, `listTemplates`; backend `schedule.service.ts` assembleDay.

**Правило сортировки:**

1. Оба с временем → по минутам от полуночи.
2. Без времени → **ниже**, между собой по `sort_order`.
3. Один с временем, один без → с временем выше.

---

## 7. Напоминания по времени рутины (новое, 2026-09-29)

До этого в RN был только **close-day 21:00** (как в PHASE6). **Routine reminders** были во Flutter, в RN — **добавлены**.

### Поведение

- Локальные **weekly** alarms (expo `SchedulableTriggerInputTypes.WEEKLY`) для каждого `(item × weekday)` если есть **время** и день в **weekdays mask**.
- Без времени — без alarm.
- Перепланирование: отмена всех scheduled с prefix `routine-*`, затем schedule заново.

### Код

| Файл | Роль |
|------|------|
| `notifications/local-notifications-core.ts` | permissions, handler, channels (shared) |
| `notifications/routine-reminder-sync.ts` | `syncRoutineReminders(items)` |
| `notifications/use-routine-reminder-sync.ts` | hook в `SyncProvider` |
| `notifications/close-day-reminder.ts` | refactored on shared core |
| `routine-screen.tsx` | sync после save/delete |
| `l10n/en.ts` | `routineTitle`, `routineBody`, обновлён `reminderStatusOk` |

### Платформы

- **Dev/release APK** — да (не Expo Go Android для полного поведения).
- **Web** — нет.

---

## 8. Git / что в коммитах vs рабочая копия

**Уже в `main` (по истории):**

- Phase 4–6, Phase 5 polish, Render blueprint + prisma/build fixes (`dceabbc`, `a165334`, `85c8c0a`, …).

**Много изменений после последних push’ей** (MCP modules, UI sheets, sort, routine notifications, DEV_PLAN §9–10) — **может быть uncommitted**; перед релизом стоит **commit + push** и redeploy Render при изменении backend.

---

## 9. Чеклист «где мы сейчас»

### Сделано

- [x] Иконки, adaptive icon, notification icon
- [x] UI polish §9 (motion, sheets, stagger, pressables)
- [x] Render API live + DEPLOY_RENDER
- [x] Backend endpoints для goals / close day / insights / sync nudge
- [x] steadyweek-mcp расширен (код)
- [x] Client MCP nudge + auto-sync
- [x] Release APK с Render URL (локальная сборка/установка)
- [x] Fix sheet re-animation
- [x] Fix Today sort by time
- [x] Routine time reminders (local)

### Отложено / не закрыто

- [ ] MCP как daily workflow (до paid Render)
- [ ] Cursor `mcp.json` стабильно на HTTPS + тот же аккаунт что телефон
- [ ] Remote MCP для cloud Claude
- [ ] Commit/push всего post-icon diff
- [ ] Store listing, uk l10n, фаза **5b** магазин
- [ ] Убрать/не коммитить секреты (`.env`, mcp.json passwords) — только локально

---

## 10. Карта файлов (ориентир для ревью)

### Frontend (главное)

```
src/ui/chrome-bottom-sheet.tsx
src/ui/motion/*
src/features/routine/routine-editor-modal.tsx
src/features/week/goal-editor-modal.tsx
src/features/today/*
src/notifications/*
src/logic/routine-schedule.ts
src/data/sync/mcp-sync-nudge.ts
src/app/sync-context.tsx
assets/* (icons)
app.json
```

### Backend

```
src/close-day/
src/weekly-goals/
src/insights/
src/day-state/ (status POST)
src/sync/ (revision, nudge)
src/common/routine-schedule.ts
src/schedule/schedule.service.ts
prisma.config.ts
```

### Repo root

```
render.yaml
docs/DEPLOY_RENDER.md
docs/DEV_PLAN.md
docs/reports/*
steadyweek-mcp/
.cursor/mcp.json.example
```

---

## 11. Рекомендуемые следующие шаги (когда вернёшься)

1. **Git commit** блоками: UI polish + bugs; notifications; backend/MCP (если ещё не в main).
2. **Release APK** после каждого значимого UX change.
3. **Paid Render** (опционально) → вернуть MCP + меньше pain на sync.
4. **5b / uk / store** по DEV_PLAN §12.

---

*Отчёт составлен по сессиям разработки и состоянию репозитория на 2026-09-29.*

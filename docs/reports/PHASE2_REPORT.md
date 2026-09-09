# Фаза 2 — отчёт (Nest + Neon + sync)

Дата: 2026-09-07  
Статус: реализовано, частично проверено вручную

---

## Цель фазы

Телефон и web делят одну облачную БД (Neon). Офлайн-режим через SQLite не ломается.

См. также: [`docs/DEV_PLAN.md`](../DEV_PLAN.md) §4.

---

## Сервер (Nest + Neon)

- NestJS API: модули **Auth**, **Routine**, **DayState**, **Sync**
- Postgres на **Neon** (проект `steadyweek`), Prisma-миграции применены
- Регистрация / логин (email + password, JWT), все строки с `user_id`
- **Pull:** `GET /sync/pull?since=` — изменения с сервера после timestamp
- **Push:** `POST /sync/push` — пачка локальных изменений с клиента
- Обновление до **Prisma ORM 7.10**:
  - `prisma.config.ts` — connection URL для CLI
  - `@prisma/adapter-pg` + `pg` Pool в `PrismaService`
  - `DATABASE_URL` убран из `schema.prisma`
- Локальные секреты в `backend/.env` (gitignored)
- Метаданные Neon: `backend/neon.project.json` (без паролей)

### Эндпоинты

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/health` | Healthcheck |
| POST | `/auth/register`, `/auth/login` | JWT + user |
| GET | `/routine` | Активные пункты рутины (`deleted_at IS NULL`) |
| GET | `/day-state?dayKey=` | Статусы дня |
| GET | `/sync/pull?since=` | Pull (JWT) |
| POST | `/sync/push` | Push (JWT) |

### Soft delete

Удаление рутины — **мягкое**: строка остаётся в Postgres с заполненным `deleted_at` (tombstone для синка). В приложении и `GET /routine` удалённые не видны.

В Neon SQL для активных записей:

```sql
SELECT id, title, sphere, updated_at
FROM routine_items
WHERE deleted_at IS NULL
ORDER BY sort_order;
```

---

## Клиент (Expo / React Native)

- SQLite: колонки `pending_sync`, таблица `sync_meta` (курсор `last_pull_at`)
- Sync engine: push pending → pull since `last_pull_at`, LWW при merge на pull
- Auth screen, токен в SecureStore
- Индикатор: **Offline / Syncing / Synced / Error** (+ текст ошибки на бейдже)
- `frontend/.env` — `EXPO_PUBLIC_API_URL` (LAN IP для Expo Go, не `localhost`)
- **Автосинк** после сохранения рутины, отметок Today, настроек (debounce 400 ms)

---

## Neon (настройка через MCP)

- Создан проект **steadyweek** (`raspy-sky-29852365`), регион `aws-eu-central-1`
- Миграции применены, таблицы: `users`, `routine_items`, `day_item_status`, `app_settings`, `user_stats`
- Регистрация и sync проверены через SQL editor Neon

---

## Дебагинг

| Проблема | Причина | Решение |
|----------|---------|---------|
| Nest не стартовал (`dist/main` not found) | `incremental` + `deleteOutDir` в watch удаляли `dist` без пересборки | `include` в `tsconfig.json`, `tsBuildInfoFile` в `dist/` |
| Backend не видел `DATABASE_URL` | Nest не загружает `.env` сам | `import 'dotenv/config'` в `main.ts` |
| Auth 500 при регистрации | `import type` для DTO — ValidationPipe не видел поля | Обычный `import` в `auth.controller.ts` |
| Сырой JSON при неверном пароле | `apiFetch` пробрасывал body ответа as-is | Парсинг JSON → «Wrong email or password» |
| «Удалил пункт, в Neon всё ещё есть» | Soft delete — строка с `deleted_at`, не hard delete | Ожидаемое поведение; фильтр `deleted_at IS NULL` |
| Sphere не обновлялся в Neon | Push молча отбрасывал по LWW; pull затирал pending-правки | Push всегда принимает клиент; pull не трогает строки с `pending_sync = 1` |
| Sync только по кнопке Sync now | Не было триггера после локальных правок | `scheduleSync()` после записей в SQLite |
| Sync error после reload Expo Go | Несколько параллельных sync + скрытая ошибка | Mutex в sync engine, меньше дублирующих триггеров, текст ошибки на бейdже, 401 → logout |
| Prisma warning в IDE (`url` deprecated) | Extension ожидал Prisma 7, проект был на 6 | Миграция на Prisma 7.10 |

---

## Проверено вручную

- [x] Регистрация → пользователь появляется в Neon (`users`)
- [x] Удаление офлайн → `deleted_at` в Neon (`routine_items`)
- [x] Sync push/pull в целом работает (после фиксов LWW и автосинка)
- [x] Неверный пароль → человекочитаемое сообщение в UI

---

## Чеклист «фаза 2 закрыта» (ещё прогнать)

- [ ] Logout → login, токен после перезапуска приложения
- [ ] Правка на web → pull на телефоне
- [ ] Правка офлайн на телефоне → появляется в Neon после wifi
- [ ] Reload Expo → бейдж **Synced** (или понятная ошибка)
- [ ] Два аккаунта — данные не смешиваются (`user_id`)

---

## Ключевые пути в репо

| Область | Путь |
|---------|------|
| Backend | `ReactNative-version/backend/` |
| Frontend | `ReactNative-version/frontend/` |
| Prisma schema | `backend/prisma/schema.prisma` |
| Sync engine (клиент) | `frontend/src/data/sync/sync-engine.ts` |
| Автосинк | `frontend/src/data/sync/schedule-sync.ts` |
| Auth UI | `frontend/src/features/auth/auth-screen.tsx` |
| Neon metadata | `backend/neon.project.json` |

---

## Не делали (следующие фазы)

- Groq-ассистент (фаза 3)
- XP, магазин, закрытие дня (фазы 4–5)
- MCP-tools (фаза 6)
- Hard delete / purge старых tombstone'ов в Postgres

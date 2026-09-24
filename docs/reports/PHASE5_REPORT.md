# Отчёт — фаза 5 (геймификация без магазина)

**Дата:** 2026-09-24  
**План:** [DEV_PLAN.md §7](../DEV_PLAN.md) · XP/уровень: [MASTER_PLAN.md §7](../MASTER_PLAN.md) · огонёk/предупреждения: [§8](../MASTER_PLAN.md)

## Итог

Фаза 5 закрыта: XP и streak (уже считались при закрытии дня в фазе 4) **показаны в UI** — уровень из total XP, карточки на профиле, предупреждения качества за скользящие 7 дней, баннер при ≥3 с переходом к ассистенту. **Shop** — заглушка «Store soon», без каталога и IAP.

Проверено на **Samsung A52** (Wi‑Fi ADB, dev client, Metro LAN, Nest на `192.168.31.232:3000`): профиль, close day, sync в Neon после миграции.

**Не входило:** Freeze «спасти огонёk» (§8.2), milestone XP за серии 7/14/30, cap бонус-задач 120, магазин с покупками — **фаза 5b**.

**Зафиксировано по продукту:** огонёk = **подряд закрытые** календарные дни (любой tier); предупреждения **не сбрасывают** streak.

---

## Что сделали

### Логика (pure, без HTTP)

| Модуль | Назначение |
|--------|------------|
| `frontend/src/logic/economy.ts` | `levelFromTotalXp` — `floor(sqrt(totalXp/100))`; `xpToNextLevel` для подписи на профиле |
| `frontend/src/logic/streak-warning-config.ts` | Окно 7 дней, порог 3 (как в MASTER §8.2) |
| `frontend/src/logic/warnings.ts` | `warningPointsForReport`: red → +1; yellow + `workImbalance` → +1; `countWarningsInWindow`, `shouldShowAssistantNudge` |
| `frontend/src/logic/streak.ts` | Без изменений по смыслу: `nextStreakAfterClose`; колонка `last_green_day_key` = последний **закрытый** день |

Кап рутины **200 XP/день** остаётся в `close-day-xp.ts` (фаза 4); отдельный UI капов не делали.

### Данные и sync

- **Домен:** `DailyReport.workImbalance: boolean`.
- **SQLite:** `phase5-migration.ts` — `ALTER TABLE daily_reports ADD COLUMN work_imbalance …` (идempotent через `PRAGMA table_info`).
- **Закрытие дня:** `day-closure-service` пишет `evaluation.workImbalance` в INSERT и в `CloseDayOutcome.report`.
- **Neon / Prisma:** миграция `20250924120000_phase5_work_imbalance` — колонка `work_imbalance BOOLEAN DEFAULT false`.
- **Sync:** DTO, mapper, `upsertDailyReport`, client `collect-pending` / `apply-pull` / `sync-types`.
- **Репозиторий:** `listDailyInDayKeyRange(startKey, endKey)` для окна предупреждений на профиле; проброс в `with-auto-sync` и memory-repos.

Старые отчёты без флага → `workImbalance = false` (ретро-warning за прошлые yellow+перекос не начисляются).

### UI и l10n

| Экран | Изменение |
|--------|-----------|
| **Profile** | Карточки Level/XP/progress, streak + hint «any tier», best, last closed; warnings X/3; баннер ≥3 → «Talk to assistant»; reload по `syncRevision` |
| **Close day** | В итоге: level; при начислении warning point — строка «Quality note… (X/3 in 7 days)» |
| **Shop** | Subtitle: «Store soon · XP cosmetics only. No IAP.» |

Строки: `frontend/src/l10n/en.ts` — секции `profile.*`, `closeDay.warningCounted`.

### Cleanup

- Удалены debug-блоки `#region agent log` и `fetch` на `127.0.0.1:7934/ingest` из `day-closure-service.ts`.

---

## Ключевые файлы

- Уровень / XP UI: `ReactNative-version/frontend/src/logic/economy.ts`
- Предупреждения: `ReactNative-version/frontend/src/logic/warnings.ts`
- Миграция SQLite: `ReactNative-version/frontend/src/data/sqlite/phase5-migration.ts`
- Закрытие + persist imbalance: `ReactNative-version/frontend/src/data/day-closure-service.ts`
- Профиль: `ReactNative-version/frontend/src/features/profile/profile-screen.tsx`
- Prisma: `ReactNative-version/backend/prisma/migrations/20250924120000_phase5_work_imbalance/`

---

## Проверено вручную (2026-09-24, A52)

- [x] Close day → tier, +XP, streak, total XP, **Level** на экране результата
- [x] Profile: Level 1, total XP, «XP to next level», streak / best / last closed (`2026-09-21` и т.д.)
- [x] **Quality warnings 3/3 (7 days)** и баннер «Rough patch this week» + кнопка ассистента
- [x] Shop → заглушка Store soon
- [x] Sync после `prisma migrate deploy` на Neon — **Synced**, без Internal server error

---

## Dev-окружение и типичные сбои

| Симптом | Причина | Что сделать |
|---------|---------|-------------|
| `ConnectException` → `192.168.31.232:3000` | Nest не запущен | `cd ReactNative-version/backend && npm run start:dev` (слушает `0.0.0.0:3000`) |
| Долгий sync → **Internal server error** | В Neon нет `work_imbalance`, клиент уже шлёт поле | `cd ReactNative-version/backend && npx prisma migrate deploy` |
| Белый экран / нет JS | Metro не запущен | `cd ReactNative-version/frontend && npm start` |
| Телефон | Wi‑Fi ADB | `adb connect <IP>:<port>`; `scripts/android-dev.ps1 -Connect "…"`; `adb reverse` 8081/3000 при необходимости |

`EXPO_PUBLIC_API_URL` в `frontend/.env` — LAN IP ПК (у нас `http://192.168.31.232:3000`). Sync требует **Sign in** (JWT).

---

## Сборка

```bash
cd ReactNative-version/backend && npm run build
cd ReactNative-version/frontend && npx tsc --noEmit
```

Перед первым sync после обновления кода фазы 5 на сервере:

```bash
cd ReactNative-version/backend
npx prisma migrate deploy
```

---

## Правки после ревью (2026-09-24)

- Огонёк пересчитывается по **всем** `day_key` в `daily_reports`, а не только от «только что закрытого» дня. Раньше закрытие вчерашнего дня после сегодняшнего ставило `last_green_day_key` на вчера и обнуляло серию.
- Строка warning на Close day только если день попадает в окно 7 дней от сегодня.
- Шаблон ассистента для yellow больше не говорит «clean slate» (огонёк не сбрасывается).
- Мусор: неиспользуемые ключи `l10n.phase4`; ссылка Assistant на профиле через l10n.

---

## Дальше

**Фаза 5b:** каталог магазина, покупки за XP, `owned_shop_items`, косметика и слои ассистента (Stitch/PNG). Опционально позже: Freeze §8.2, milestone XP за streak 7/14/30.

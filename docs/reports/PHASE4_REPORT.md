# Отчёт — фаза 4 (продукт поверх графика)

**Дата:** 2026-09-19  
**План:** [DEV_PLAN.md §6](../DEV_PLAN.md) · спека качества дня: [MASTER_PLAN.md §6](../MASTER_PLAN.md)

## Итог

Фаза 4 закрыта: недельные цели, закрытие дня с расчётом **green / yellow / red**, полоска качества на Week, недельный отчёт с заметками. Данные живут в SQLite, уходят в Neon через sync (LWW). На dev-сборке (A52, Wi‑Fi ADB) сценарии проверены; sync между устройствами работает.

**Не входило в фазу:** магазин, профиль с XP, uk, Groq после закрытия (только шаблонная фраза), предупреждения «огонька» (фаза 5).

---

## Что сделали

### Данные и sync

- **SQLite:** таблицы `weekly_goals`, `daily_reports`, `weekly_reports`, флаги `pending_sync`.
- **Neon / Prisma:** те же сущности, миграция `20250919120000_phase4_goals_reports` (на проде: `npx prisma migrate deploy` в `ReactNative-version/backend`).
- **Sync:** push/pull для целей, дневных и недельных отчётов; stats по-прежнему при закрытии дня.

### Логика

- **`evaluateDay`** — чистая функция: R (обязательная рутина), S (сферы с done), перекос work, качество отчёта E → tier. Пороги в `evaluation-config.ts`.
- **`day-closure-service`** — одно закрытие на `dayKey`, XP + streak, запись `DailyReport`.
- **`computeWeeklyReportSummary`** — агрегаты для экрана недельного отчёта.

### UI

| Экран | Функция |
|--------|---------|
| **Week** | Навигация по неделям, полоска tier, CRUD целей (модалка), ссылка на отчёт |
| **Today** | Карточка целей (+1), Close day с выбранной датой, блок повторного закрытия |
| **Close day** | Форма, итог tier / XP / streak, шаблон ассистента |
| **Weekly report** | Сводка недели, поля win / focus, сохранение + sync |

### Доработки после первого прогона

- Клавиатура не перекрывает модалку цели и поля Weekly report: `useKeyboardBottomInset`, прокрутка, `softwareKeyboardLayoutMode: resize` в `app.json` (полный эффект resize — после следующего native-билда).
- Скрипт `android-dev.ps1`: правки строк для PowerShell.

---

## Ключевые файлы

- Миграция клиента: `ReactNative-version/frontend/src/data/sqlite/phase4-migration.ts`
- Закрытие дня: `ReactNative-version/frontend/src/data/day-closure-service.ts`
- Оценка дня: `ReactNative-version/frontend/src/logic/evaluate-day.ts`
- Экраны: `features/week/`, `features/close-day/`, `features/weekly-report/`, `features/today/today-weekly-goals-card.tsx`
- Sync (сервер): `ReactNative-version/backend/src/sync/sync.service.ts`

---

## Проверено вручную

- [x] Цели: создание на Week, +1 на Today, completed при target
- [x] Close day → tier, XP, «Day closed», повторное закрытие запрещено
- [x] Полоска Week после закрытий; переход на Today по дню
- [x] Weekly report: цифры, сохранение win/focus
- [x] Sync / Neon: изменения видны на втором клиенте после pull (в т.ч. в «реальном» режиме авто-sync)

---

## Сборка

```bash
cd ReactNative-version/backend && npm run build
cd ReactNative-version/frontend && npx tsc --noEmit
```

Dev на телефоне: Metro + `EXPO_PUBLIC_API_URL` на LAN IP ПК, `scripts/android-dev.ps1` (pair Wi‑Fi при необходимости).

---

## Правки после ревью (2026-09-19)

- **`day-closure-service`:** оценка дня (`evaluateDay`), XP (`xpForClosedDay`) и огонёк (`nextStreakAfterClose`) вынесены в `logic/`. В сервисе остались проверка «уже закрыт» внутри транзакции, INSERT отчёта и UPDATE stats.
- Огонёк: **любое** закрытие (green / yellow / red) даёт +1, если вчера тоже закрыт; сброс только если пропустил день без close (MASTER_PLAN §6.3 / §8.1).
- Нельзя закрыть **будущий** день; mood только 1–5; заметки обрезаются (как sync DTO). Дублирующий `reportFor` убран — экран читает `reports.getDaily`.
- Sync DTO: `dayKey` формата даты, mood 1–5, `xpAwarded` ≤ 500.

---

## Дальше (фаза 5)

XP и streak в профиле, магазин, огонёк и предупреждения по MASTER_PLAN §8.

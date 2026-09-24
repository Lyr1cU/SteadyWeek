# Отчёт — полировка UI (§9 DEV_PLAN)

**Дата:** 2026-09-24  
**План:** [DEV_PLAN.md §9](../DEV_PLAN.md) · референс: Flutter `flutter-version/`, glass/chrome из макета

## Итог

Основные экраны RN-клиента приведены к единому **glass/chrome**-стилю: floating tab dock, карточки на `GlassSurface`, модалки и меню в одной палитре (lavender accent). Добавлен слой **motion** (Reanimated): смена табов, push/pop экранов, появление блоков, press-feedback на CTA. Строки вынесены в **`l10n` → `en.ts`** (routine, profile, closeDay, weeklyReport, assistant).

**Не входило:** магазин (5b), uk, Lottie, React Navigation stack, shared-element transitions.

---

## Оболочка (shell)

| Изменение | Детали |
|-----------|--------|
| **Tab bar** | Glass dock (Today / Week / Routine / Profile), активный таб — gradient pill, цвета из `theme.ts` (`navDockBorder`, `navActiveGradient*`) |
| **Sync badge** | Над dock (debug при логине), не перекрывает табы — `main-shell.tsx`, `DOCK_LAYOUT_HEIGHT` |
| **Tab motion** | `TabCrossfade` — slide влево/вправо по индексу таба; табы на `AnimatedPressable` |
| **Route motion** | `RouteSlide` в `navigator.tsx` — shell ↔ closeDay / weeklyReport / assistant / shop / auth |

---

## Today

- Контекстное меню пункта дня: **`ChromeContextMenu`** вместо системного `Alert` (Skip / Undo skip).
- Карточки пунктов уже на glass (сфера, время, чек, ⋮).
- **Motion:** `StaggerFadeIn` на date bar, title, goals, rows, Close day CTA; FAB ассистента и CTA — `AnimatedPressable`.

---

## Week

- **`WeekNavBar`**, **`WeekQualityStrip`**, **`WeekGoalCard`**, **`WeekReportCta`** — glass, tier-цвета полоски дней.
- Цели: meta + progress bar, ⋮ → Edit / Remove.
- Header **+ Add** pill.
- Empty goals — glass-карточка + ссылка Add.
- **Motion:** stagger по секциям; Add pill — `AnimatedPressable`.
- **`GoalEditorModal`:** Reanimated `FadeInDown` + fade backdrop, `animationType="none"`.

---

## Routine

- Список: **`RoutineCard`** на glass (символ сферы, одна meta-строка, badge optional, ⋮ Edit/Delete).
- Highlight редактируемой карточки — accent rim.
- **Add item:** pill в шапке → **`RoutineEditorModal`** (bottom sheet), не inline-форма.
- Delete: **`ChromeConfirmDialog`**.
- **`routine.*`** в l10n; `TAB_BAR_CLEARANCE` под dock.
- **Motion:** stagger на карточках; Add pill — `AnimatedPressable`.

---

## Profile (Phase 5 UI)

- **`ProfileLevelCard`** — XP progress bar (`xpProgressInLevel` в `economy.ts`).
- **`ProfileStreakCard`** — flame, meta Best · Last closed, warnings badge (amber при пороге).
- **`ProfileNudgeCard`** — amber rim, CTA «Talk to assistant» — lavender primary.
- Settings / Account — glass + **`ProfileMenuRow`** / **`ProfileInfoRow`** (иконки, chevron).
- Guest — glass hint + Sign in.
- **`profile.*`** l10n (Sync, Sign in/out, секции).
- **Motion:** stagger; menu rows — `AnimatedPressable`.

---

## Close day

- Шапка: chevron Back, читаемая дата, subtitle.
- **`CloseDayFormCard`** — glass, inputs с lavender border, mood 1…N (scale UI), hint «1 = rough · 5 = great».
- **`CloseDayResultCard`** — tier rim (green/yellow/red) через **`day-tier-ui.ts`**, warning badge, assistant inset, Done.
- Already closed — glass banner.
- **`closeDay.*`** l10n; keyboard inset.
- **Motion:** stagger header + form/result; submit/Done — `AnimatedPressable`.

---

## Weekly report

- Диапазон недели человекочитаемый (`Mon … – Sun …`).
- **`WeeklyReportSummaryCard`** — glass + tier pills (Green/Yellow/Red counts).
- **`WeeklyReportNotesCard`** — Win / Focus + Save notes в glass.
- **`weeklyReport.*`** l10n.
- **Motion:** stagger; Save — `AnimatedPressable`.

---

## Assistant

- Шапка: chevron, formatted day context, status pill (Groq / templates).
- **`AssistantMessageBubble`** — glass для assistant, lavender user bubble, chip Groq/Template, `FadeInUp`.
- **`AssistantTypingBubble`** — pulsing «…».
- **`AssistantComposer`** — glass dock, pill input, round Send (`AnimatedPressable`).
- **`AssistantQuickPrompts`** — lavender-border chips.
- **`assistant.*`** l10n (расширено).
- Auto-scroll чата при новых сообщениях.

---

## Общие UI-компоненты (новые / доработанные)

| Файл | Назначение |
|------|------------|
| `ui/glass-surface.tsx` | Frosted card (уже был; используется повсеместно) |
| `ui/chrome-context-menu.tsx` | Flutter-style ⋮ menu |
| `ui/chrome-confirm-dialog.tsx` | Styled confirm + Reanimated `ZoomIn` |
| `ui/day-tier-ui.ts` | `tierRimStyle` для close day / weekly summary |
| `ui/sphere-ui.ts` | Labels/symbols сфер на карточках |
| `ui/motion/tab-crossfade.tsx` | Slide между табами |
| `ui/motion/route-slide.tsx` | Slide push/pop маршрутов |
| `ui/motion/stagger-fade-in.tsx` | Появление блоков с cap задержки |
| `ui/motion/animated-pressable.tsx` | Scale 0.96 + opacity press |
| `ui/motion/constants.ts` | Durations, `useReduceMotion` |

Модалки routine/goal и chrome menu/confirm: **`animationType="none"`** + Reanimated, без двойной анимации.

---

## Локализация

Расширены секции в [`ReactNative-version/frontend/src/l10n/en.ts`](../../ReactNative-version/frontend/src/l10n/en.ts):

- `routine.*` — экран, форма, ошибки, delete confirm  
- `profile.*` — screen, account, settings  
- `closeDay.*` — форма, tier, errors  
- `weeklyReport.*` — summary + notes  
- `assistant.*` — title, day context, source chips, typing  

Uk — по-прежнему фаза 6.

---

## Motion — поведение и доступность

- Все анимации уважают **`AccessibilityInfo` reduce motion** (`useReduceMotion` → duration 0 / без entering).
- Длительности: tab ~200 ms, screen ~280 ms, modal ~260 ms, press ~120 ms.
- Stagger: шаг 40 ms, cap индекса 8 (`staggerIndexCap`), чтобы длинные списки не «ползли».
- Ellipsis ⋮ на карточках — обычный `Pressable` (без scale), чтобы меню не дёргалось.

---

## Ключевые папки фич

```
ReactNative-version/frontend/src/features/
  shell/          main-shell, shell-tab-bar
  today/          today-item (+ ChromeContextMenu)
  week/           week-*-card, goal-editor-modal
  routine/        routine-card, routine-editor-modal, routine-list
  profile/        profile-*-card, profile-menu-row
  close-day/      close-day-form-card, close-day-result-card
  weekly-report/  weekly-report-*-card
  assistant/      assistant-message-bubble, assistant-composer, assistant-quick-prompts
```

---

## Проверено вручную (рекомендуемый чеклист)

- [ ] Табы: slide при Today ↔ Week ↔ Routine ↔ Profile; dock не прыгает
- [ ] Push: Close day, Weekly report, Assistant — slide справа; Back — обратно
- [ ] Routine: + Add item → sheet; Edit/Delete; confirm delete
- [ ] Week: Add goal modal; quality strip tap → Today focus
- [ ] Profile: level bar, streak, nudge, menu rows press
- [ ] Close day: form → result tier colors; mood chips
- [ ] Weekly report: summary pills, save notes
- [ ] Assistant: bubbles, typing, quick prompts, send
- [ ] Reduce motion ON (система): нет slide/stagger или мгновенно

---

## Сборка

```bash
cd ReactNative-version/frontend && npx tsc --noEmit
```

После изменений motion: перезапуск Metro; Reanimated plugin уже в `babel.config.js`.

---

## Связь с DEV_PLAN §9

Покрыто по смыслу:

- Glass / единообразие списков и профиля  
- Tabbar, модалки, keyboard inset (close day / weekly / routine / goals)  
- Chrome menus и confirm  
- Короткие анимации (таб, блоки, press, sheets)  

Остаётся на усмотрение следующих итераций: полный audit всех вторичных экранов (Shop, Auth, Onboarding), FAB ассистента как во Flutter extended, uk l10n.

---

## Дальше

- **5b** — магазин и ассеты (после §9 «готово когда»).  
- При желании: отметить чекбоксы §9 в DEV_PLAN и короткая ссылка на этот отчёт в §11.

---

## Правки после ревью (2026-09-24)

- Week / Routine / Profile больше не добавляют второй `118` под dock: отступ уже в `main-shell`.
- `RouteSlide` слой на `absoluteFill`, чтобы push/pop не складывал два экрана столбиком.
- Reduce motion: пока система не ответила, анимации выключены (первый кадр не вспыхивал).
- Удалены неиспользуемые `ShellOverlay`, `screenEasing`, импорт `FadeIn` в табах.
- `react-native-reanimated` и `worklets` объявлены в `package.json` (babel-plugin уже их требует).
- Снят debug-`fetch` на `127.0.0.1` из закрытия дня.

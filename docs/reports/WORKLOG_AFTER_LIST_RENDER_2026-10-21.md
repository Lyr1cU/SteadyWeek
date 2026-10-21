# Worklog: рендер списков → точные напоминания → свайп дней и недель

**Дата:** 2026-10-21  
**Точка отсчёта:** баг отрисовки Today / Routine / Week / Profile — контент вспыхивал готовым, пропадал и заново проигрывал появление.  
**Статус на конец:** release APK на Samsung A57 (SM_A576B), API `https://steadyweek-api.onrender.com`. Изменения в рабочей копии, отдельным коммитом не закрыты.

См. также: [`WORKLOG_AFTER_ICONS_2026-09-29.md`](./WORKLOG_AFTER_ICONS_2026-09-29.md), [`UI_POLISH_REPORT.md`](./UI_POLISH_REPORT.md).

---

## 1. Баг рендера списков

### Как выглядело

- **Today:** сначала рисовалась кнопка Close day, потом подгружались пункты рутины и кнопка прыгала вниз.
- **Routine:** пункты появлялись из локальной базы, на миг пропадали после синка с Render и заново проигрывали stagger.
- Следующая итерация убрала прыжок, но страница всё равно дёргалась: готовый экран успевал отрисоваться, исчезал и входил анимацией ещё раз.
- Счётчик «24 items» на Routine появлялся сразу и не участвовал в том же входе, что заголовок и карточки.

### Почему

- Вкладки shell остаются смонтированными (`ShellPane`). Ключ входа увеличивался в `useEffect` уже после первого кадра, поэтому список успевал нарисоваться статично и потом перемонтировался в `StaggerFadeIn`.
- `useReduceMotion` стартовал с `true`. Первый кадр был обычным `View`, затем подмена на `Animated.View` давала второй рывок.
- У выхода карточек стоял `FadeOut`: при обновлении данных строки мигали.
- Счётчик шаблонов был обычным `Text` между заголовком (index 0) и карточками (тоже с 0).

### Что сделали

| Место | Поведение |
|-------|-----------|
| `shell-pane.tsx` | Пока вкладка не готова к входу, ключ `-1`. Реальный контент монтируется один раз, вместе с анимацией. Повторный синк ключ не увеличивает. |
| `use-reduce-motion.ts` | Стартовое значение `false`, чтобы первый кадр не был статичной копией. |
| `stagger-fade-in.tsx` | Только `FadeInDown`, без `FadeOut`. |
| `list-skeleton.tsx` | Плейсхолдер «Loading» для Today и Routine, пока данные и ключ входа не готовы. |
| Today / Week / Profile | Тело списка (заголовок, карточки, CTA) монтируется только когда `showBody`. Дата и каркас экрана остаются. |
| Routine | Счётчик в `StaggerFadeIn` с index 1, карточки с `index + 2`. |

Пользователь подтвердил, что вход списков стал тем, который нужен: сначала скелетон, потом один общий проигрыш, без повторного дёрганья после синка.

---

## 2. Напоминания рутины приходили с опозданием

### Симптом

Локальные напоминания «пора заняться делом» приходили без устойчивого паттерна: иногда примерно на 10 минут позже, иногда меньше, иногда больше. Подозрение было и на баг приложения, и на холодный старт Render.

### Диагноз

Напоминания ставятся **на телефоне** (`expo-notifications`, weekly trigger), не пушем с сервера. Render влияет только на то, когда список рутины пересинхронизируется и будильники перезапишутся. Уже поставленный будильник Render не задерживает.

В `ExpoSchedulingDelegate` точный `setExactAndAllowWhileIdle` вызывается только если `AlarmManager.canScheduleExactAlarms()` истинен. Иначе Android ставит неточный `setAndAllowWhileIdle`. На Samsung это и даёт плавающие минуты: Doze и экономия батареи. Во Flutter-версии тот же сценарий шёл через `exactAllowWhileIdle` и `requestExactAlarmsPermission`. В RN-сборке разрешения на точный будильник не было.

Запись в системные Samsung Reminders снаружи приложения недоступна. Близкий заметный режим — наше полноэкранное уведомление поверх блокировки.

---

## 3. Два режима напоминаний

Оба режима точные и срабатывают при выключенном экране. Переключатель в Profile → Settings.

| Режим | Что видит человек |
|-------|-------------------|
| **Shade** | Уведомление в шторке, звук, вибрация, в ту же минуту, что стоит в рутине. |
| **Full screen** | В ту же минуту включается экран и поверх блокировки показывается напоминание. Первый выбор просит системное разрешение на полноэкранные уведомления. |

Close day в 21:00 использует тот же режим.

### Как устроено

- Каналы новые (`routine_reminders_exact` / `routine_reminders_screen`, то же для close day). Android не меняет importance уже созданного канала, поэтому id другие.
- Важность HIGH для шторки и MAX для полного экрана. Звук default, на полном экране usage `ALARM`.
- В `data` уведомления флаг `fullScreen: true`. Патч `expo-notifications` в `ExpoNotificationBuilder` ставит `setFullScreenIntent` на `ReminderAlarmActivity`.
- Модуль `frontend/modules/steadyweek-alarms`: разрешения `USE_EXACT_ALARM`, `SCHEDULE_EXACT_ALARM`, `USE_FULL_SCREEN_INTENT`, экран напоминания, открытие системных настроек, если точный будильник или полный экран ещё не разрешены.
- `expo-notifications` собирается из исходников (`package.json` → `expo.autolinking.android.buildFromSource`), иначе Gradle берёт готовый AAR и патч не попадает в APK. Патч хранится в `frontend/patches/expo-notifications+57.0.18.patch`, применяется `patch-package` на `postinstall`.
- Режим хранится локально в Secure Store (`reminder_presentation`), в облачный синк не уходит.
- Тест в профиле: **Test reminder (8 sec)**. После нажатия телефон нужно заблокировать.
- По возврату из системных настроек будильники переставляются (`AppState` → `syncRoutineReminders`), потому что тип alarm (точный или нет) выбирается в момент постановки.

### Ограничение

Если Samsung усыпляет приложение целиком, точный будильник тоже может не прийти. Это уже список спящих приложений, не канал уведомлений.

---

## 4. Низ Today: не докрутить список

### Симптом

Close day обрезалась нижней панелью, кнопка ассистента пряталась под ней. Докрутить ниже было нельзя.

### Почему

Вкладки — `position: 'absolute'` на весь `ShellPane`. Отступ `paddingBottom` у родителя они не учитывают, поэтому запас в 118px под док не работал. Контент кончался под панелью.

Кратко ставили `marginBottom` на тело shell: список заканчивался выше дока, но за индикатором Synced появлялась пустая полоса. Раньше список просвечивал сквозь эту зону.

### Как сейчас

- Тело shell снова на всю высоту. Индикатор Synced / Offline / Syncing прозрачный и лежит поверх списка.
- У ScrollView снизу запас `TAB_BAR_CLEARANCE` (118), на Today ещё +72, чтобы Close day уезжала выше кнопки ассистента.
- Кнопка ассистента стоит над доком (`bottom: TAB_BAR_CLEARANCE - 22`), а не у края экрана.

Тот же нижний запас добавлен на Week, Routine и Profile, иначе последний блок снова уезжал бы под панель.

---

## 5. Свайп дней и недель

- **Today:** свайп влево — следующий день, вправо — предыдущий. Стрелки в шапке даты остались.
- **Week:** тот же жест листает недели (±7 дней). Стрелки в `WeekNavBar` остались.
- Жест — `Gesture.Pan` (`use-horizontal-page-swipe.ts`). Горизонталь от 24px активирует смену страницы, вертикаль от 18px отдаёт прокрутку списку. Порог срабатывания 56px.
- Корень приложения обёрнут в `GestureHandlerRootView` (`App.tsx`). Импорт `react-native-gesture-handler` уже был в `index.ts`.

Вертикальный скролл списка при этом сохраняется.

---

## 6. Сборки на телефон

Устройство: Samsung A57, `SM_A576B`, Wi-Fi adb `192.168.31.181`. Код сопряжения одноразовый.

Release: `npx expo run:android --variant release --no-bundler`, `EXPO_PUBLIC_API_URL=https://steadyweek-api.onrender.com`. На время сборки в `android/gradle.properties` выставлялись `org.gradle.parallel=false` и `reactNativeArchitectures=arm64-v8a` (иначе ninja падает на armeabi-v7a), после сборки файл возвращался к полному списку ABI и `parallel=true`.

`adb install` по Wi-Fi иногда зависал без прогресса. Рабочий обход: `adb push` APK в `/data/local/tmp` и `pm install -r -d`. Expo после установки открывает `exp+steadyweek-rn://expo-development-client/?url=...:8081` — это не релизный экран. Приложение запускали через launcher category `com.steadyweek.app`.

Нативные куски (модуль будильников и патч уведомлений) в уже стоящий APK не подтягиваются горячей перезагрузкой. Каждый из этих шагов ставился новым release.

---

## 7. Карта файлов

```
frontend/src/ui/motion/shell-pane.tsx
frontend/src/ui/motion/use-reduce-motion.ts
frontend/src/ui/motion/stagger-fade-in.tsx
frontend/src/ui/motion/use-horizontal-page-swipe.ts
frontend/src/ui/motion/constants.ts
frontend/src/ui/list-skeleton.tsx
frontend/src/features/today/today-screen.tsx
frontend/src/features/routine/routine-screen.tsx
frontend/src/features/routine/routine-list.tsx
frontend/src/features/week/week-screen.tsx
frontend/src/features/profile/profile-screen.tsx
frontend/src/features/shell/main-shell.tsx
frontend/src/app/App.tsx
frontend/src/notifications/routine-reminder-sync.ts
frontend/src/notifications/close-day-reminder.ts
frontend/src/notifications/local-notifications-core.ts
frontend/src/notifications/reminder-presentation.ts
frontend/src/notifications/reminder-channels.ts
frontend/src/notifications/use-routine-reminder-sync.ts
frontend/modules/steadyweek-alarms/
frontend/patches/expo-notifications+57.0.18.patch
```

`android/` по-прежнему генерируется и в git не входит. Разрешения будильника продублированы в `app.json`, чтобы следующий prebuild их не потерял.

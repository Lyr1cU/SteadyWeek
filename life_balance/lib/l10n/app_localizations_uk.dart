// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Баланс життя';

  @override
  String get navToday => 'Сьогодні';

  @override
  String get navWeek => 'Тиждень';

  @override
  String get navRoutine => 'Рутина';

  @override
  String get navShop => 'Крамниця';

  @override
  String get navProfile => 'Профіль';

  @override
  String get settingsAppearance => 'Вигляд';

  @override
  String get notifCloseDayTitle => 'Баланс життя';

  @override
  String get notifCloseDayBody =>
      'Хвилина, щоб закрити день і підбитись підсумок.';

  @override
  String get notifCloseDaySection => 'Щоденне нагадування';

  @override
  String get notifCloseDayToggle => 'Нагадувати закрити день';

  @override
  String get notifCloseDayTime => 'Час сповіщення';

  @override
  String notifRoutineBody(String title) {
    return 'Час для: $title';
  }

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get languageSystem => 'Системна';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get themeSystem => 'Як у системі';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get phaseAPlaceholder =>
      'Каркас фази A — далі дані й сценарії з MASTER_PLAN.';

  @override
  String get todayEmpty =>
      'На цей день немає пунктів рутини. Додай їх у «Рутина».';

  @override
  String get todayWeeklyGoalsHeading => 'Цілі тижня';

  @override
  String get todayWeeklyGoalsOpenWeek => 'Тиждень';

  @override
  String get todayWeeklyGoalsEmpty =>
      'Ще немає цілей на цей тиждень. Додай на вкладці «Тиждень».';

  @override
  String get jumpToToday => 'До сьогодні';

  @override
  String get sphereWork => 'Робота / навчання';

  @override
  String get sphereBody => 'Тіло й здоров’я';

  @override
  String get sphereSocial => 'Люди';

  @override
  String get sphereRest => 'Відпочинок і приємності';

  @override
  String get sphereHome => 'Дім';

  @override
  String get sphereGrowth => 'Розвиток';

  @override
  String get sphereFieldLabel => 'Сфера життя';

  @override
  String get addRoutineItem => 'Додати пункт рутини';

  @override
  String get editRoutineItem => 'Редагувати пункт рутини';

  @override
  String get routineTitleHint => 'Назва';

  @override
  String get activeDays => 'Активні дні';

  @override
  String get save => 'Зберегти';

  @override
  String get actionCancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get weekdayMonShort => 'Пн';

  @override
  String get weekdayTueShort => 'Вт';

  @override
  String get weekdayWedShort => 'Ср';

  @override
  String get weekdayThuShort => 'Чт';

  @override
  String get weekdayFriShort => 'Пт';

  @override
  String get weekdaySatShort => 'Сб';

  @override
  String get weekdaySunShort => 'Нд';

  @override
  String get weekGoalsEmpty =>
      'Немає цілей на цей тиждень. Додай одну, щоб тримати курс.';

  @override
  String get weekQualityStripTitle => 'Закриті дні';

  @override
  String get dayNotClosed => 'Ще не закрито';

  @override
  String get weekGoToTodayForDay => 'Відкрити в «Сьогодні»';

  @override
  String get weeklyReportTitle => 'Підсумок тижня';

  @override
  String get weeklyReportOpen => 'Огляд тижня';

  @override
  String get weeklyReportStatsHeading => 'Коротко';

  @override
  String weeklyReportDaysClosed(int closed, int total) {
    return 'закрито $closed з $total днів';
  }

  @override
  String weeklyReportTierCounts(int green, int yellow, int red) {
    return '$green збалансовано · $yellow нормально · $red важко';
  }

  @override
  String weeklyReportXpWeek(int xp) {
    return '$xp досвіду з закритих днів цього тижня';
  }

  @override
  String weeklyReportGoalsSummary(int completed, int total) {
    return 'виконано $completed з $total тижневих цілей';
  }

  @override
  String get weeklyNoteWinHint => 'Що вдалося цього тижня?';

  @override
  String get weeklyNoteFocusHint => 'Що найважливіше наступного тижня?';

  @override
  String get weeklyReportSave => 'Зберегти нотатки';

  @override
  String get weeklyReportSaved => 'Тижневі нотатки збережено.';

  @override
  String get addWeeklyGoal => 'Додати тижневу ціль';

  @override
  String get weeklyGoalTitleHint => 'Назва цілі';

  @override
  String get targetTimes => 'Ціль (разів)';

  @override
  String get thisWeek => 'Цей тиждень';

  @override
  String get previousWeek => 'Попередній';

  @override
  String get nextWeek => 'Наступний';

  @override
  String goalProgressLabel(int current, int target) {
    return '$current / $target';
  }

  @override
  String get addProgress => '+1';

  @override
  String get goalDone => 'Готово';

  @override
  String get closeDay => 'Закрити день';

  @override
  String get closeDayTitle => 'Закрий свій день';

  @override
  String get noteHighlightHint => 'Що виділялось сьогодні?';

  @override
  String get noteReflectionHint => 'Що береш із собою завтра?';

  @override
  String get moodOptional => 'Настрій (необов’язково)';

  @override
  String get moodClear => 'Очистити';

  @override
  String get submitCloseDay => 'Зберегти й отримати досвід';

  @override
  String get dayAlreadyClosed => 'Цей день уже закрито.';

  @override
  String get daySummary => 'Підсумок дня';

  @override
  String get tierGreen => 'Збалансований день';

  @override
  String get tierYellow => 'Нормальний день';

  @override
  String get tierRed => 'Важкий день';

  @override
  String xpGained(int xp) {
    return '+$xp досвіду';
  }

  @override
  String get streakNow => 'Поточна серія';

  @override
  String get totalXpLabel => 'Усього досвіду';

  @override
  String get bestStreakLabel => 'Найкраща серія';

  @override
  String get closeDaySuccess => 'Чудово — ти отримав(-ла) досвід.';

  @override
  String get reportQualityTip =>
      'Для «зеленого» дня заповни обидві нотатки (від 2 символів кожна) або додай настрій і «що виділялось».';

  @override
  String get back => 'Назад';

  @override
  String get scheduleFlexible => 'Будь-коли';

  @override
  String get scheduleTimeOptional => 'Час (необов’язково)';

  @override
  String get scheduleSetTime => 'Задати час';

  @override
  String get scheduleNoTime => 'Без фіксованого часу';

  @override
  String get onboardingAppBarTitle => 'Ласкаво просимо';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingNext => 'Далі';

  @override
  String get onboardingBack => 'Назад';

  @override
  String get onboardingGetStarted => 'Почати';

  @override
  String get onboardingWelcomeTitle => 'Привіт, друже';

  @override
  String get onboardingWelcomeBody =>
      'SteadyWeek допомагає тримати лагідний тижневий ритм — не список із сотні пунктів повинності.';

  @override
  String get onboardingWelcomeBody2 =>
      'Один тиждень за раз — маленькі кроки, які можна повторювати.';

  @override
  String get onboardingPhilosophyTitle => 'Баланс важливіший за перевантаження';

  @override
  String get onboardingPhilosophyBody =>
      'Закрити день важливіше, ніж відмітити кожен пункт. «Зелені» дні за чесність, не за ідеал.';

  @override
  String get onboardingSpheresTitle => 'Шість сфер життя';

  @override
  String get onboardingSpheresBody =>
      'Робота, тіло, люди, відпочинок, дім і розвиток — рамка для цілей і рутини. Деталі можна змінити в «Рутина».';

  @override
  String get onboardingPlanTitle => 'Рутина і тижневі цілі';

  @override
  String get onboardingPlanBody =>
      'Додай кілька пунктів рутини й одну-дві цілі на цей тиждень — почни з малого. Редагувати можна у вкладках «Рутина» та «Тиждень».';

  @override
  String get onboardingFinishTitle => 'Майже готово';

  @override
  String get onboardingNameHint => 'Як до тебе звертатись? (необов’язково)';

  @override
  String get onboardingTourTitle => 'Куди натискати';

  @override
  String get onboardingTourToday => 'Сьогодні — таймлайн і цілі дня.';

  @override
  String get onboardingTourWeek =>
      'Тиждень — цілі, кольори днів і підсумок тижня.';

  @override
  String get onboardingTourCloseDay =>
      'Іконка місяця — закрити день і отримати досвід.';

  @override
  String get onboardingTourProfile => 'Профіль — серія та налаштування.';

  @override
  String get authTitle => 'Акаунт і резервні копії';

  @override
  String get authSubtitle =>
      'Увійди, щоб синхронізувати й відновити дані, коли під’єднаємо хмару. Поки все працює повністю на цьому пристрої.';

  @override
  String get authEmailHint => 'Електронна пошта';

  @override
  String get authPasswordHint => 'Пароль';

  @override
  String get authSignIn => 'Увійти';

  @override
  String get authComingSoon =>
      'Хмарний вхід не налаштований для цієї збірки — дані лишаються на пристрої. Додай SUPABASE_URL і SUPABASE_ANON_KEY як dart-define, щоб увімкнути.';

  @override
  String get authSignedIn =>
      'Ти увійшов(-ла). Повний синк даних ще не зроблено — джерелом правди лишається цей пристрій.';

  @override
  String get authSignInFailed => 'Не вдалося увійти.';

  @override
  String get authContinueOffline => 'Далі без мережі';

  @override
  String get profileDisplayName => 'Твоє ім’я';

  @override
  String get profileOpenAuth => 'Акаунт і резервні копії';

  @override
  String get routineSkipToday => 'Пропустити сьогодні';

  @override
  String get routineSkippedForToday => 'Пропущено сьогодні';

  @override
  String get routineUndoSkip => 'Скасувати пропуск';

  @override
  String get routineSkipSnackbar =>
      'Позначено як пропущено. Залишиться в плані на наступний запланований день.';

  @override
  String get routineSkipSnackbarTomorrow =>
      'Пропущено сьогодні — завтра в списку знову буде.';

  @override
  String shopYourBalance(int xp) {
    return '$xp досвіду';
  }

  @override
  String get shopBuy => 'Купити';

  @override
  String get shopOwned => 'У колекції';

  @override
  String get shopNotEnoughXp => 'Недостатньо досвіду.';

  @override
  String shopLockedStreak(int n) {
    return 'Відкривається при найкращій серії від $n.';
  }

  @override
  String get shopPurchaseSuccess => 'Додано до колекції.';

  @override
  String get shopAlreadyOwned => 'У тебе вже є.';

  @override
  String get shopFilterAll => 'Усе';

  @override
  String get shopFilterProfile => 'Профіль';

  @override
  String get shopFilterAssistant => 'Асистент';

  @override
  String get shopCategoryProfileBg => 'Тло профілю';

  @override
  String get shopCategoryFrame => 'Рамка аватара';

  @override
  String get shopCategoryNameStyle => 'Стиль імені';

  @override
  String get shopCategoryAssistant => 'Асистент';

  @override
  String get shopCategoryVoice => 'Голосовий пакет';

  @override
  String get shopItemCalmMistBgTitle => 'Тло «Спокійна мла»';

  @override
  String get shopItemCalmMistBgDesc =>
      'М’який бірюзово-фіолетовий градієнт за карткою профілю.';

  @override
  String get shopItemDawnGradientBgTitle => 'Тло «Світанковий градієнт»';

  @override
  String get shopItemDawnGradientBgDesc =>
      'Теплі тони сходу для шапки профілю.';

  @override
  String get shopItemLavenderSoftFrameTitle => 'Рамка «Ніжна лаванда»';

  @override
  String get shopItemLavenderSoftFrameDesc =>
      'Закруглена рамка з лагідним фіолетовим сяйвом.';

  @override
  String get shopItemEmberStreakFrameTitle => 'Рамка «Жар серії»';

  @override
  String get shopItemEmberStreakFrameDesc =>
      'Для сталого балансу — потрібна міцна серія.';

  @override
  String get shopItemNameGradientGoldTitle => 'Золотий градієнт імені';

  @override
  String get shopItemNameGradientGoldDesc =>
      'Ледь помітне золоте сяйво на відображуваному імені.';

  @override
  String get shopItemNameSoftVioletTitle => 'Ім’я «Ніжний фіолет»';

  @override
  String get shopItemNameSoftVioletDesc =>
      'Стриманий фіолетовий акцент на рядку імені.';

  @override
  String get shopItemAssistantCapPartyTitle => 'Шапка для асистента';

  @override
  String get shopItemAssistantCapPartyDesc =>
      'Жартівлива шапочка на аватар асистента.';

  @override
  String get shopItemAssistantScarfCozyTitle => 'Шарфик для асистента';

  @override
  String get shopItemAssistantScarfCozyDesc => 'Теплий шарф — зимовий настрій.';

  @override
  String get shopItemVoicePackLaconicTitle => 'Пакет «Лаконічний голос»';

  @override
  String get shopItemVoicePackLaconicDesc => 'Короткі сухі репліки асистента.';

  @override
  String get shopItemStickerBalanceSetTitle => 'Набір стикерів балансу';

  @override
  String get shopItemStickerBalanceSetDesc =>
      'Маленькі стикери для етапів у сцені асистента.';

  @override
  String get shopUseBackground => 'Увімкнути';

  @override
  String get shopBackgroundActive => 'Активно';

  @override
  String get profileBackgroundSection => 'Шапка профілю';

  @override
  String get profileAvatarFrameSection => 'Рамка аватара';

  @override
  String get profileNameStyleSection => 'Стиль імені';

  @override
  String get profileCosmeticDefault => 'За замовчуванням';

  @override
  String get profileLookUpdated => 'Оновлено вигляд профілю.';

  @override
  String assistantCloseGreenA(int streak) {
    return '$streak зелених днів поспіль — це вже ритм.';
  }

  @override
  String get assistantCloseGreenB =>
      'Ти закрив(-ла) день з балансом. Це важливіше за ідеальний чеклист.';

  @override
  String get assistantCloseYellowA =>
      'Нормальний день записано. Завтра — чиста сторінка.';

  @override
  String get assistantCloseYellowB =>
      'Жовті дні теж рахуються. Відпочинь, якщо тіло просить.';

  @override
  String get assistantCloseRedA =>
      'Нелегко — але ти все одно чесно закрив(-ла) день. Це сміливо.';

  @override
  String get assistantCloseRedB =>
      'Червоні дні бувають. Сьогодні будь лагідним(-ою) до себе.';

  @override
  String get assistantShopA =>
      'Нове сяйво в колекції — насолоджуйся атмосферою.';

  @override
  String get assistantShopB =>
      'Досвід витрачено з розумом. Потіш себе моментом.';

  @override
  String get assistantGoalDoneA =>
      'Тижнева ціль закрита — цій частині життя реально приділили увагу.';

  @override
  String get assistantGoalDoneB =>
      'Одна ціль менше. Маленькі кроки теж рухають гори.';

  @override
  String get assistantTodayCardTitle => 'Помічник балансу';

  @override
  String get assistantTodayCardHint =>
      'Навіть один маленький крок зі списку вже вперед.';

  @override
  String get assistantScreenTitle => 'Помічник балансу';

  @override
  String get assistantScreenTileSubtitle => 'Шари, голос і крамниця';

  @override
  String get assistantScreenIntro =>
      'З’являються на «Сьогодні» й підтримують, коли ти закриваєш день, купуєш щось або завершуєш тижневу ціль.';

  @override
  String get assistantScreenLayersHeading => 'Шари вигляду';

  @override
  String get assistantScreenLayersEmpty =>
      'Ще немає шарів. Відкрий Крамницю → Асистент для шапок, шарфів і стикерів.';

  @override
  String get assistantScreenVoiceHeading => 'Як говорить';

  @override
  String get assistantScreenVoiceDefaultTitle => 'Голос за замовчуванням';

  @override
  String get assistantScreenVoiceDefault => 'Теплі, повні речення.';

  @override
  String get assistantScreenVoiceLaconicLine =>
      'Пакет «Лаконічний»: короткі сухі фрази.';

  @override
  String get assistantOpenShopAssistant => 'Товари асистента в Крамниці';

  @override
  String assistantLaconicCloseGreenA(int streak) {
    return '$streak зелених поспіль. Клас.';
  }

  @override
  String get assistantLaconicCloseGreenB => 'Закриття з балансом.';

  @override
  String get assistantLaconicCloseYellowA => 'Норм день. Завтра відкрите.';

  @override
  String get assistantLaconicCloseYellowB => 'Жовтий теж зараховується.';

  @override
  String get assistantLaconicCloseRedA => 'Важкий день. Зафіксовано.';

  @override
  String get assistantLaconicCloseRedB => 'Будь до себе м’якше.';

  @override
  String get assistantLaconicShopA => 'Гарний улов.';

  @override
  String get assistantLaconicShopB => 'Гарна витрата.';

  @override
  String get assistantLaconicGoalA => 'Ціль зроблена.';

  @override
  String get assistantLaconicGoalB => 'Маленька перемога.';

  @override
  String get profileDbBackupTitle => 'Резервна копія бази';

  @override
  String get profileDbBackupSubtitle =>
      'Експорт або заміна локальної SQLite на пристрої. Не містить вхід у хмару чи налаштування сповіщень.';

  @override
  String get profileDbBackupExport => 'Експортувати копію…';

  @override
  String get profileDbBackupImport => 'Відновити з файлу…';

  @override
  String get profileDbBackupShareSubject => 'Резервна копія бази Life Balance';

  @override
  String profileDbBackupExportError(String message) {
    return 'Не вдалося експортувати: $message';
  }

  @override
  String get profileDbBackupNotSqlite =>
      'Обери коректний файл SQLite цієї програми (…sqlite).';

  @override
  String get profileDbBackupImportConfirmTitle => 'Замінити локальні дані?';

  @override
  String get profileDbBackupImportConfirmBody =>
      'Уся рутина, цілі, закриття днів і прогрес крамниці на цьому пристрої будуть замінені резервною копією. Застосунок перезапуститься.';

  @override
  String get profileDbBackupRestart => 'Відновити й перезапустити';
}

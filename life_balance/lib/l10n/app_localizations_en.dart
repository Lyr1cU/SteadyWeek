// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Life Balance';

  @override
  String get navToday => 'Today';

  @override
  String get navWeek => 'Week';

  @override
  String get navRoutine => 'Routine';

  @override
  String get navShop => 'Shop';

  @override
  String get navProfile => 'Profile';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get notifCloseDayTitle => 'Life Balance';

  @override
  String get notifCloseDayBody =>
      'Take a minute to close your day and check in.';

  @override
  String get notifCloseDaySection => 'Daily reminder';

  @override
  String get notifCloseDayToggle => 'Remind me to close the day';

  @override
  String get notifCloseDayTime => 'Notification time';

  @override
  String notifRoutineBody(String title) {
    return 'Time for: $title';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUkrainian => 'Ukrainian';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get phaseAPlaceholder =>
      'Phase A scaffold — data and flows from MASTER_PLAN next.';

  @override
  String get todayEmpty =>
      'No routine items for this day. Add some under Routine.';

  @override
  String get todayWeeklyGoalsHeading => 'Weekly goals';

  @override
  String get todayWeeklyGoalsOpenWeek => 'Week';

  @override
  String get todayWeeklyGoalsEmpty =>
      'No goals for this week yet. Add them on the Week tab.';

  @override
  String get jumpToToday => 'Jump to today';

  @override
  String get sphereWork => 'Work / study';

  @override
  String get sphereBody => 'Body & health';

  @override
  String get sphereSocial => 'People';

  @override
  String get sphereRest => 'Rest & fun';

  @override
  String get sphereHome => 'Home';

  @override
  String get sphereGrowth => 'Growth';

  @override
  String get sphereFieldLabel => 'Life area';

  @override
  String get addRoutineItem => 'Add routine item';

  @override
  String get editRoutineItem => 'Edit routine item';

  @override
  String get routineTitleHint => 'Title';

  @override
  String get activeDays => 'Active days';

  @override
  String get save => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get weekdayMonShort => 'Mon';

  @override
  String get weekdayTueShort => 'Tue';

  @override
  String get weekdayWedShort => 'Wed';

  @override
  String get weekdayThuShort => 'Thu';

  @override
  String get weekdayFriShort => 'Fri';

  @override
  String get weekdaySatShort => 'Sat';

  @override
  String get weekdaySunShort => 'Sun';

  @override
  String get weekGoalsEmpty =>
      'No goals for this week. Add one to stay on track.';

  @override
  String get weekQualityStripTitle => 'Closed days';

  @override
  String get dayNotClosed => 'Not closed yet';

  @override
  String get weekGoToTodayForDay => 'Open in Today';

  @override
  String get weeklyReportTitle => 'Week in review';

  @override
  String get weeklyReportOpen => 'Review week';

  @override
  String get weeklyReportStatsHeading => 'At a glance';

  @override
  String weeklyReportDaysClosed(int closed, int total) {
    return '$closed of $total days closed';
  }

  @override
  String weeklyReportTierCounts(int green, int yellow, int red) {
    return '$green balanced · $yellow okay · $red tough';
  }

  @override
  String weeklyReportXpWeek(int xp) {
    return '$xp XP from closed days this week';
  }

  @override
  String weeklyReportGoalsSummary(int completed, int total) {
    return '$completed of $total weekly goals completed';
  }

  @override
  String get weeklyNoteWinHint => 'What went well this week?';

  @override
  String get weeklyNoteFocusHint => 'What matters most next week?';

  @override
  String get weeklyReportSave => 'Save notes';

  @override
  String get weeklyReportSaved => 'Weekly notes saved.';

  @override
  String get addWeeklyGoal => 'Add weekly goal';

  @override
  String get weeklyGoalTitleHint => 'Goal title';

  @override
  String get targetTimes => 'Target (times)';

  @override
  String get thisWeek => 'This week';

  @override
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String goalProgressLabel(int current, int target) {
    return '$current / $target';
  }

  @override
  String get addProgress => '+1';

  @override
  String get goalDone => 'Done';

  @override
  String get closeDay => 'Close day';

  @override
  String get closeDayTitle => 'Close your day';

  @override
  String get noteHighlightHint => 'What stood out today?';

  @override
  String get noteReflectionHint => 'What do you take into tomorrow?';

  @override
  String get moodOptional => 'Mood (optional)';

  @override
  String get moodClear => 'Clear';

  @override
  String get submitCloseDay => 'Save & earn XP';

  @override
  String get dayAlreadyClosed => 'This day is already closed.';

  @override
  String get daySummary => 'Day summary';

  @override
  String get tierGreen => 'Balanced day';

  @override
  String get tierYellow => 'Okay day';

  @override
  String get tierRed => 'Tough day';

  @override
  String xpGained(int xp) {
    return '+$xp XP';
  }

  @override
  String get streakNow => 'Current streak';

  @override
  String get totalXpLabel => 'Total XP';

  @override
  String get bestStreakLabel => 'Best streak';

  @override
  String get closeDaySuccess => 'Great — you earned XP.';

  @override
  String get reportQualityTip =>
      'For a balanced (green) day, fill both notes (2+ characters each) or add mood + highlight.';

  @override
  String get back => 'Back';

  @override
  String get scheduleFlexible => 'Any time';

  @override
  String get scheduleTimeOptional => 'Time (optional)';

  @override
  String get scheduleSetTime => 'Set time';

  @override
  String get scheduleNoTime => 'No fixed time';

  @override
  String get onboardingAppBarTitle => 'Welcome';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingWelcomeTitle => 'Hi, friend';

  @override
  String get onboardingWelcomeBody =>
      'SteadyWeek helps you keep a kind weekly rhythm — not a hundred-item guilt list.';

  @override
  String get onboardingWelcomeBody2 =>
      'One week at a time — small steps you can actually repeat.';

  @override
  String get onboardingPhilosophyTitle => 'Balance beats overload';

  @override
  String get onboardingPhilosophyBody =>
      'Closing your day matters more than checking every box. Green days reward honesty, not perfection.';

  @override
  String get onboardingSpheresTitle => 'Six life areas';

  @override
  String get onboardingSpheresBody =>
      'Work, body, people, rest, home, and growth frame your goals and routine. You can tune details anytime in Routine.';

  @override
  String get onboardingPlanTitle => 'Routine & weekly goals';

  @override
  String get onboardingPlanBody =>
      'Add a few routine items and one or two goals for this week — start small. You’ll edit them under the Routine and Week tabs.';

  @override
  String get onboardingFinishTitle => 'Almost there';

  @override
  String get onboardingNameHint => 'What should we call you? (optional)';

  @override
  String get onboardingTourTitle => 'Where to tap';

  @override
  String get onboardingTourToday =>
      'Today — your timeline and goals for the day.';

  @override
  String get onboardingTourWeek =>
      'Week — goals, day colors, and week in review.';

  @override
  String get onboardingTourCloseDay => 'Moon icon — close the day and earn XP.';

  @override
  String get onboardingTourProfile => 'Profile — streak and settings.';

  @override
  String get authTitle => 'Account & backup';

  @override
  String get authSubtitle =>
      'Sign in to sync and recover your data when we connect the cloud. For now the app works fully on this device.';

  @override
  String get authEmailHint => 'Email';

  @override
  String get authPasswordHint => 'Password';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authComingSoon =>
      'Cloud sign-in is not configured for this build — your data stays on the device. Add SUPABASE_URL and SUPABASE_ANON_KEY as dart-defines to enable.';

  @override
  String get authSignedIn =>
      'Signed in. Full data sync is not implemented yet — this device stays the source of truth.';

  @override
  String get authSignInFailed => 'Could not sign in.';

  @override
  String get authContinueOffline => 'Continue offline';

  @override
  String get profileDisplayName => 'Your name';

  @override
  String get profileOpenAuth => 'Account & backup';

  @override
  String get routineSkipToday => 'Skip for today';

  @override
  String get routineSkippedForToday => 'Skipped today';

  @override
  String get routineUndoSkip => 'Undo skip';

  @override
  String get routineSkipSnackbar =>
      'Marked skipped. It stays on your plan for the next scheduled day.';

  @override
  String get routineSkipSnackbarTomorrow =>
      'Skipped for today — it\'s still on tomorrow\'s list.';

  @override
  String shopYourBalance(int xp) {
    return '$xp XP';
  }

  @override
  String get shopBuy => 'Buy';

  @override
  String get shopOwned => 'Owned';

  @override
  String get shopNotEnoughXp => 'Not enough XP.';

  @override
  String shopLockedStreak(int n) {
    return 'Unlocks at best streak $n or higher.';
  }

  @override
  String get shopPurchaseSuccess => 'Added to your collection.';

  @override
  String get shopAlreadyOwned => 'You already own this.';

  @override
  String get shopFilterAll => 'All';

  @override
  String get shopFilterProfile => 'Profile';

  @override
  String get shopFilterAssistant => 'Assistant';

  @override
  String get shopCategoryProfileBg => 'Profile background';

  @override
  String get shopCategoryFrame => 'Avatar frame';

  @override
  String get shopCategoryNameStyle => 'Name style';

  @override
  String get shopCategoryAssistant => 'Assistant';

  @override
  String get shopCategoryVoice => 'Voice pack';

  @override
  String get shopItemCalmMistBgTitle => 'Calm Mist background';

  @override
  String get shopItemCalmMistBgDesc =>
      'Soft teal-violet gradient behind your profile card.';

  @override
  String get shopItemDawnGradientBgTitle => 'Dawn Gradient background';

  @override
  String get shopItemDawnGradientBgDesc =>
      'Warm sunrise tones for your profile header.';

  @override
  String get shopItemLavenderSoftFrameTitle => 'Soft Lavender frame';

  @override
  String get shopItemLavenderSoftFrameDesc =>
      'Rounded frame with a gentle purple glow.';

  @override
  String get shopItemEmberStreakFrameTitle => 'Ember Streak frame';

  @override
  String get shopItemEmberStreakFrameDesc =>
      'For consistent balance — requires a solid streak.';

  @override
  String get shopItemNameGradientGoldTitle => 'Golden name gradient';

  @override
  String get shopItemNameGradientGoldDesc =>
      'Subtle gold shimmer on your display name.';

  @override
  String get shopItemNameSoftVioletTitle => 'Violet ink name';

  @override
  String get shopItemNameSoftVioletDesc =>
      'Muted violet emphasis for your name line.';

  @override
  String get shopItemAssistantCapPartyTitle => 'Party cap layer';

  @override
  String get shopItemAssistantCapPartyDesc =>
      'A playful cap for your assistant avatar.';

  @override
  String get shopItemAssistantScarfCozyTitle => 'Cozy scarf layer';

  @override
  String get shopItemAssistantScarfCozyDesc =>
      'Warm scarf slot — winter vibes.';

  @override
  String get shopItemVoicePackLaconicTitle => 'Laconic voice pack';

  @override
  String get shopItemVoicePackLaconicDesc => 'Short, dry assistant one-liners.';

  @override
  String get shopItemStickerBalanceSetTitle => 'Balance sticker set';

  @override
  String get shopItemStickerBalanceSetDesc =>
      'Tiny stickers for milestones in your assistant scene.';

  @override
  String get shopUseBackground => 'Use';

  @override
  String get shopBackgroundActive => 'Active';

  @override
  String get profileBackgroundSection => 'Profile header';

  @override
  String get profileAvatarFrameSection => 'Avatar frame';

  @override
  String get profileNameStyleSection => 'Name style';

  @override
  String get profileCosmeticDefault => 'Default';

  @override
  String get profileLookUpdated => 'Profile look updated.';

  @override
  String assistantCloseGreenA(int streak) {
    return '$streak green days in a row — that rhythm is real.';
  }

  @override
  String get assistantCloseGreenB =>
      'You closed with balance. That matters more than a perfect checklist.';

  @override
  String get assistantCloseYellowA =>
      'Logged an okay day. Tomorrow is a clean page.';

  @override
  String get assistantCloseYellowB =>
      'Yellow days still count. Rest if your body asks for it.';

  @override
  String get assistantCloseRedA =>
      'Tough one — you still closed it honestly. That takes guts.';

  @override
  String get assistantCloseRedB =>
      'Red days happen. Be gentle with yourself tonight.';

  @override
  String get assistantShopA =>
      'New sparkle in your collection — enjoy the vibe.';

  @override
  String get assistantShopB => 'XP well spent. Treat yourself to the moment.';

  @override
  String get assistantGoalDoneA =>
      'Weekly goal wrapped — that part of life got real attention.';

  @override
  String get assistantGoalDoneB =>
      'One goal done. Small steps still move mountains.';

  @override
  String get assistantTodayCardTitle => 'Balance buddy';

  @override
  String get assistantTodayCardHint =>
      'One tiny step on your list still counts as forward.';

  @override
  String get assistantScreenTitle => 'Balance buddy';

  @override
  String get assistantScreenTileSubtitle => 'Layers, voice, and shop';

  @override
  String get assistantScreenIntro =>
      'They show up on Today and chime in when you close the day, buy something, or finish a weekly goal.';

  @override
  String get assistantScreenLayersHeading => 'Look layers';

  @override
  String get assistantScreenLayersEmpty =>
      'No layers yet. Open the Shop → Assistant for hats, scarves, and stickers.';

  @override
  String get assistantScreenVoiceHeading => 'How they talk';

  @override
  String get assistantScreenVoiceDefaultTitle => 'Default voice';

  @override
  String get assistantScreenVoiceDefault => 'Warm, full sentences.';

  @override
  String get assistantScreenVoiceLaconicLine =>
      'Laconic pack: short, dry one-liners.';

  @override
  String get assistantOpenShopAssistant => 'Assistant items in Shop';

  @override
  String assistantLaconicCloseGreenA(int streak) {
    return '$streak green streak. Nice.';
  }

  @override
  String get assistantLaconicCloseGreenB => 'Balanced close.';

  @override
  String get assistantLaconicCloseYellowA => 'Okay day. Tomorrow’s open.';

  @override
  String get assistantLaconicCloseYellowB => 'Yellow still counts.';

  @override
  String get assistantLaconicCloseRedA => 'Rough day. Logged.';

  @override
  String get assistantLaconicCloseRedB => 'Be easy on yourself.';

  @override
  String get assistantLaconicShopA => 'Nice grab.';

  @override
  String get assistantLaconicShopB => 'Good spend.';

  @override
  String get assistantLaconicGoalA => 'Goal done.';

  @override
  String get assistantLaconicGoalB => 'Small win.';

  @override
  String get profileDbBackupTitle => 'Local database backup';

  @override
  String get profileDbBackupSubtitle =>
      'Export or replace your on-device SQLite data. Does not include sign-in or notification settings.';

  @override
  String get profileDbBackupExport => 'Export backup…';

  @override
  String get profileDbBackupImport => 'Restore from file…';

  @override
  String get profileDbBackupShareSubject => 'Life Balance database backup';

  @override
  String profileDbBackupExportError(String message) {
    return 'Could not export: $message';
  }

  @override
  String get profileDbBackupNotSqlite =>
      'Choose a valid SQLite file from this app (…sqlite).';

  @override
  String get profileDbBackupImportConfirmTitle => 'Replace local data?';

  @override
  String get profileDbBackupImportConfirmBody =>
      'All routine, goals, closes, and shop progress on this device will be replaced with the backup. The app will restart.';

  @override
  String get profileDbBackupRestart => 'Restore and restart';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Life Balance'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get navWeek;

  /// No description provided for @navRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get navRoutine;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @notifCloseDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Life Balance'**
  String get notifCloseDayTitle;

  /// No description provided for @notifCloseDayBody.
  ///
  /// In en, this message translates to:
  /// **'Take a minute to close your day and check in.'**
  String get notifCloseDayBody;

  /// No description provided for @notifCloseDaySection.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get notifCloseDaySection;

  /// No description provided for @notifCloseDayToggle.
  ///
  /// In en, this message translates to:
  /// **'Remind me to close the day'**
  String get notifCloseDayToggle;

  /// No description provided for @notifCloseDayTime.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get notifCloseDayTime;

  /// No description provided for @notifRoutineBody.
  ///
  /// In en, this message translates to:
  /// **'Time for: {title}'**
  String notifRoutineBody(String title);

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get languageUkrainian;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Temporary copy on placeholder screens
  ///
  /// In en, this message translates to:
  /// **'Phase A scaffold — data and flows from MASTER_PLAN next.'**
  String get phaseAPlaceholder;

  /// No description provided for @todayEmpty.
  ///
  /// In en, this message translates to:
  /// **'No routine items for this day. Add some under Routine.'**
  String get todayEmpty;

  /// No description provided for @todayWeeklyGoalsHeading.
  ///
  /// In en, this message translates to:
  /// **'Weekly goals'**
  String get todayWeeklyGoalsHeading;

  /// No description provided for @todayWeeklyGoalsOpenWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get todayWeeklyGoalsOpenWeek;

  /// No description provided for @todayWeeklyGoalsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No goals for this week yet. Add them on the Week tab.'**
  String get todayWeeklyGoalsEmpty;

  /// No description provided for @jumpToToday.
  ///
  /// In en, this message translates to:
  /// **'Jump to today'**
  String get jumpToToday;

  /// No description provided for @sphereWork.
  ///
  /// In en, this message translates to:
  /// **'Work / study'**
  String get sphereWork;

  /// No description provided for @sphereBody.
  ///
  /// In en, this message translates to:
  /// **'Body & health'**
  String get sphereBody;

  /// No description provided for @sphereSocial.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get sphereSocial;

  /// No description provided for @sphereRest.
  ///
  /// In en, this message translates to:
  /// **'Rest & fun'**
  String get sphereRest;

  /// No description provided for @sphereHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get sphereHome;

  /// No description provided for @sphereGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get sphereGrowth;

  /// No description provided for @sphereFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Life area'**
  String get sphereFieldLabel;

  /// No description provided for @addRoutineItem.
  ///
  /// In en, this message translates to:
  /// **'Add routine item'**
  String get addRoutineItem;

  /// No description provided for @editRoutineItem.
  ///
  /// In en, this message translates to:
  /// **'Edit routine item'**
  String get editRoutineItem;

  /// No description provided for @routineTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get routineTitleHint;

  /// No description provided for @activeDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get activeDays;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @weekdayMonShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMonShort;

  /// No description provided for @weekdayTueShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTueShort;

  /// No description provided for @weekdayWedShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWedShort;

  /// No description provided for @weekdayThuShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThuShort;

  /// No description provided for @weekdayFriShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFriShort;

  /// No description provided for @weekdaySatShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySatShort;

  /// No description provided for @weekdaySunShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySunShort;

  /// No description provided for @weekGoalsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No goals for this week. Add one to stay on track.'**
  String get weekGoalsEmpty;

  /// No description provided for @weekQualityStripTitle.
  ///
  /// In en, this message translates to:
  /// **'Closed days'**
  String get weekQualityStripTitle;

  /// No description provided for @dayNotClosed.
  ///
  /// In en, this message translates to:
  /// **'Not closed yet'**
  String get dayNotClosed;

  /// No description provided for @weekGoToTodayForDay.
  ///
  /// In en, this message translates to:
  /// **'Open in Today'**
  String get weekGoToTodayForDay;

  /// No description provided for @weeklyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Week in review'**
  String get weeklyReportTitle;

  /// No description provided for @weeklyReportOpen.
  ///
  /// In en, this message translates to:
  /// **'Review week'**
  String get weeklyReportOpen;

  /// No description provided for @weeklyReportStatsHeading.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get weeklyReportStatsHeading;

  /// No description provided for @weeklyReportDaysClosed.
  ///
  /// In en, this message translates to:
  /// **'{closed} of {total} days closed'**
  String weeklyReportDaysClosed(int closed, int total);

  /// No description provided for @weeklyReportTierCounts.
  ///
  /// In en, this message translates to:
  /// **'{green} balanced · {yellow} okay · {red} tough'**
  String weeklyReportTierCounts(int green, int yellow, int red);

  /// No description provided for @weeklyReportXpWeek.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP from closed days this week'**
  String weeklyReportXpWeek(int xp);

  /// No description provided for @weeklyReportGoalsSummary.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} weekly goals completed'**
  String weeklyReportGoalsSummary(int completed, int total);

  /// No description provided for @weeklyNoteWinHint.
  ///
  /// In en, this message translates to:
  /// **'What went well this week?'**
  String get weeklyNoteWinHint;

  /// No description provided for @weeklyNoteFocusHint.
  ///
  /// In en, this message translates to:
  /// **'What matters most next week?'**
  String get weeklyNoteFocusHint;

  /// No description provided for @weeklyReportSave.
  ///
  /// In en, this message translates to:
  /// **'Save notes'**
  String get weeklyReportSave;

  /// No description provided for @weeklyReportSaved.
  ///
  /// In en, this message translates to:
  /// **'Weekly notes saved.'**
  String get weeklyReportSaved;

  /// No description provided for @addWeeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Add weekly goal'**
  String get addWeeklyGoal;

  /// No description provided for @weeklyGoalTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Goal title'**
  String get weeklyGoalTitleHint;

  /// No description provided for @targetTimes.
  ///
  /// In en, this message translates to:
  /// **'Target (times)'**
  String get targetTimes;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @previousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get previousWeek;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get nextWeek;

  /// No description provided for @goalProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target}'**
  String goalProgressLabel(int current, int target);

  /// No description provided for @addProgress.
  ///
  /// In en, this message translates to:
  /// **'+1'**
  String get addProgress;

  /// No description provided for @goalDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get goalDone;

  /// No description provided for @closeDay.
  ///
  /// In en, this message translates to:
  /// **'Close day'**
  String get closeDay;

  /// No description provided for @closeDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Close your day'**
  String get closeDayTitle;

  /// No description provided for @noteHighlightHint.
  ///
  /// In en, this message translates to:
  /// **'What stood out today?'**
  String get noteHighlightHint;

  /// No description provided for @noteReflectionHint.
  ///
  /// In en, this message translates to:
  /// **'What do you take into tomorrow?'**
  String get noteReflectionHint;

  /// No description provided for @moodOptional.
  ///
  /// In en, this message translates to:
  /// **'Mood (optional)'**
  String get moodOptional;

  /// No description provided for @moodClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get moodClear;

  /// No description provided for @submitCloseDay.
  ///
  /// In en, this message translates to:
  /// **'Save & earn XP'**
  String get submitCloseDay;

  /// No description provided for @dayAlreadyClosed.
  ///
  /// In en, this message translates to:
  /// **'This day is already closed.'**
  String get dayAlreadyClosed;

  /// No description provided for @daySummary.
  ///
  /// In en, this message translates to:
  /// **'Day summary'**
  String get daySummary;

  /// No description provided for @tierGreen.
  ///
  /// In en, this message translates to:
  /// **'Balanced day'**
  String get tierGreen;

  /// No description provided for @tierYellow.
  ///
  /// In en, this message translates to:
  /// **'Okay day'**
  String get tierYellow;

  /// No description provided for @tierRed.
  ///
  /// In en, this message translates to:
  /// **'Tough day'**
  String get tierRed;

  /// No description provided for @xpGained.
  ///
  /// In en, this message translates to:
  /// **'+{xp} XP'**
  String xpGained(int xp);

  /// No description provided for @streakNow.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get streakNow;

  /// No description provided for @totalXpLabel.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXpLabel;

  /// No description provided for @bestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreakLabel;

  /// No description provided for @closeDaySuccess.
  ///
  /// In en, this message translates to:
  /// **'Great — you earned XP.'**
  String get closeDaySuccess;

  /// No description provided for @reportQualityTip.
  ///
  /// In en, this message translates to:
  /// **'For a balanced (green) day, fill both notes (2+ characters each) or add mood + highlight.'**
  String get reportQualityTip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @scheduleFlexible.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get scheduleFlexible;

  /// No description provided for @scheduleTimeOptional.
  ///
  /// In en, this message translates to:
  /// **'Time (optional)'**
  String get scheduleTimeOptional;

  /// No description provided for @scheduleSetTime.
  ///
  /// In en, this message translates to:
  /// **'Set time'**
  String get scheduleSetTime;

  /// No description provided for @scheduleNoTime.
  ///
  /// In en, this message translates to:
  /// **'No fixed time'**
  String get scheduleNoTime;

  /// No description provided for @routineSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get routineSelectTime;

  /// No description provided for @onboardingAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingAppBarTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi, friend'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'SteadyWeek helps you keep a kind weekly rhythm — not a hundred-item guilt list.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingWelcomeBody2.
  ///
  /// In en, this message translates to:
  /// **'One week at a time — small steps you can actually repeat.'**
  String get onboardingWelcomeBody2;

  /// No description provided for @onboardingPhilosophyTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance beats\noverload'**
  String get onboardingPhilosophyTitle;

  /// No description provided for @onboardingPhilosophyBody.
  ///
  /// In en, this message translates to:
  /// **'Closing your day matters more than checking every box. Green days reward honesty, not perfection.'**
  String get onboardingPhilosophyBody;

  /// No description provided for @onboardingSpheresTitle.
  ///
  /// In en, this message translates to:
  /// **'Six life areas'**
  String get onboardingSpheresTitle;

  /// No description provided for @onboardingSpheresBody.
  ///
  /// In en, this message translates to:
  /// **'Work, body, people, rest, home, and growth frame your goals and routine. You can tune details anytime in Routine.'**
  String get onboardingSpheresBody;

  /// No description provided for @onboardingPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Routine & weekly goals'**
  String get onboardingPlanTitle;

  /// No description provided for @onboardingPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Add a few routine items and one or two goals for this week — start small. You’ll edit them under the Routine and Week tabs.'**
  String get onboardingPlanBody;

  /// No description provided for @onboardingFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get onboardingFinishTitle;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'What should we call you? (optional)'**
  String get onboardingNameHint;

  /// No description provided for @onboardingTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to tap'**
  String get onboardingTourTitle;

  /// No description provided for @onboardingTourToday.
  ///
  /// In en, this message translates to:
  /// **'Today — your timeline and goals for the day.'**
  String get onboardingTourToday;

  /// No description provided for @onboardingTourWeek.
  ///
  /// In en, this message translates to:
  /// **'Week — goals, day colors, and week in review.'**
  String get onboardingTourWeek;

  /// No description provided for @onboardingTourWeekLine1.
  ///
  /// In en, this message translates to:
  /// **'• Week — goals, day colors,'**
  String get onboardingTourWeekLine1;

  /// No description provided for @onboardingTourWeekLine2.
  ///
  /// In en, this message translates to:
  /// **'and your weekly snapshot.'**
  String get onboardingTourWeekLine2;

  /// No description provided for @onboardingTourCloseDay.
  ///
  /// In en, this message translates to:
  /// **'Moon icon — close the day and earn XP.'**
  String get onboardingTourCloseDay;

  /// No description provided for @onboardingTourProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile — streak and settings.'**
  String get onboardingTourProfile;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & backup'**
  String get authTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync and recover your data when we connect the cloud. For now the app works fully on this device.'**
  String get authSubtitle;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordHint;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Cloud sign-in is not configured for this build — your data stays on the device. Add SUPABASE_URL and SUPABASE_ANON_KEY as dart-defines to enable.'**
  String get authComingSoon;

  /// No description provided for @authSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in. Full data sync is not implemented yet — this device stays the source of truth.'**
  String get authSignedIn;

  /// No description provided for @authSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in.'**
  String get authSignInFailed;

  /// No description provided for @authContinueOffline.
  ///
  /// In en, this message translates to:
  /// **'Continue offline'**
  String get authContinueOffline;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileDisplayName;

  /// No description provided for @profileOpenAuth.
  ///
  /// In en, this message translates to:
  /// **'Account & backup'**
  String get profileOpenAuth;

  /// No description provided for @routineSkipToday.
  ///
  /// In en, this message translates to:
  /// **'Skip for today'**
  String get routineSkipToday;

  /// No description provided for @routineSkippedForToday.
  ///
  /// In en, this message translates to:
  /// **'Skipped today'**
  String get routineSkippedForToday;

  /// No description provided for @routineUndoSkip.
  ///
  /// In en, this message translates to:
  /// **'Undo skip'**
  String get routineUndoSkip;

  /// No description provided for @routineSkipSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Marked skipped. It stays on your plan for the next scheduled day.'**
  String get routineSkipSnackbar;

  /// No description provided for @routineSkipSnackbarTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Skipped for today — it\'s still on tomorrow\'s list.'**
  String get routineSkipSnackbarTomorrow;

  /// No description provided for @shopYourBalance.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String shopYourBalance(int xp);

  /// No description provided for @shopBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get shopBuy;

  /// No description provided for @shopOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get shopOwned;

  /// No description provided for @shopNotEnoughXp.
  ///
  /// In en, this message translates to:
  /// **'Not enough XP.'**
  String get shopNotEnoughXp;

  /// No description provided for @shopLockedStreak.
  ///
  /// In en, this message translates to:
  /// **'Unlocks at best streak {n} or higher.'**
  String shopLockedStreak(int n);

  /// No description provided for @shopPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added to your collection.'**
  String get shopPurchaseSuccess;

  /// No description provided for @shopAlreadyOwned.
  ///
  /// In en, this message translates to:
  /// **'You already own this.'**
  String get shopAlreadyOwned;

  /// No description provided for @shopFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get shopFilterAll;

  /// No description provided for @shopFilterProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get shopFilterProfile;

  /// No description provided for @shopFilterAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get shopFilterAssistant;

  /// No description provided for @shopCategoryProfileBg.
  ///
  /// In en, this message translates to:
  /// **'Profile background'**
  String get shopCategoryProfileBg;

  /// No description provided for @shopCategoryFrame.
  ///
  /// In en, this message translates to:
  /// **'Avatar frame'**
  String get shopCategoryFrame;

  /// No description provided for @shopCategoryNameStyle.
  ///
  /// In en, this message translates to:
  /// **'Name style'**
  String get shopCategoryNameStyle;

  /// No description provided for @shopCategoryAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get shopCategoryAssistant;

  /// No description provided for @shopCategoryVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice pack'**
  String get shopCategoryVoice;

  /// No description provided for @shopItemCalmMistBgTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm Mist background'**
  String get shopItemCalmMistBgTitle;

  /// No description provided for @shopItemCalmMistBgDesc.
  ///
  /// In en, this message translates to:
  /// **'Soft teal-violet gradient behind your profile card.'**
  String get shopItemCalmMistBgDesc;

  /// No description provided for @shopItemDawnGradientBgTitle.
  ///
  /// In en, this message translates to:
  /// **'Dawn Gradient background'**
  String get shopItemDawnGradientBgTitle;

  /// No description provided for @shopItemDawnGradientBgDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm sunrise tones for your profile header.'**
  String get shopItemDawnGradientBgDesc;

  /// No description provided for @shopItemLavenderSoftFrameTitle.
  ///
  /// In en, this message translates to:
  /// **'Soft Lavender frame'**
  String get shopItemLavenderSoftFrameTitle;

  /// No description provided for @shopItemLavenderSoftFrameDesc.
  ///
  /// In en, this message translates to:
  /// **'Rounded frame with a gentle purple glow.'**
  String get shopItemLavenderSoftFrameDesc;

  /// No description provided for @shopItemEmberStreakFrameTitle.
  ///
  /// In en, this message translates to:
  /// **'Ember Streak frame'**
  String get shopItemEmberStreakFrameTitle;

  /// No description provided for @shopItemEmberStreakFrameDesc.
  ///
  /// In en, this message translates to:
  /// **'For consistent balance — requires a solid streak.'**
  String get shopItemEmberStreakFrameDesc;

  /// No description provided for @shopItemNameGradientGoldTitle.
  ///
  /// In en, this message translates to:
  /// **'Golden name gradient'**
  String get shopItemNameGradientGoldTitle;

  /// No description provided for @shopItemNameGradientGoldDesc.
  ///
  /// In en, this message translates to:
  /// **'Subtle gold shimmer on your display name.'**
  String get shopItemNameGradientGoldDesc;

  /// No description provided for @shopItemNameSoftVioletTitle.
  ///
  /// In en, this message translates to:
  /// **'Violet ink name'**
  String get shopItemNameSoftVioletTitle;

  /// No description provided for @shopItemNameSoftVioletDesc.
  ///
  /// In en, this message translates to:
  /// **'Muted violet emphasis for your name line.'**
  String get shopItemNameSoftVioletDesc;

  /// No description provided for @shopItemAssistantCapPartyTitle.
  ///
  /// In en, this message translates to:
  /// **'Party cap layer'**
  String get shopItemAssistantCapPartyTitle;

  /// No description provided for @shopItemAssistantCapPartyDesc.
  ///
  /// In en, this message translates to:
  /// **'A playful cap for your assistant avatar.'**
  String get shopItemAssistantCapPartyDesc;

  /// No description provided for @shopItemAssistantScarfCozyTitle.
  ///
  /// In en, this message translates to:
  /// **'Cozy scarf layer'**
  String get shopItemAssistantScarfCozyTitle;

  /// No description provided for @shopItemAssistantScarfCozyDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm scarf slot — winter vibes.'**
  String get shopItemAssistantScarfCozyDesc;

  /// No description provided for @shopItemVoicePackLaconicTitle.
  ///
  /// In en, this message translates to:
  /// **'Laconic voice pack'**
  String get shopItemVoicePackLaconicTitle;

  /// No description provided for @shopItemVoicePackLaconicDesc.
  ///
  /// In en, this message translates to:
  /// **'Short, dry assistant one-liners.'**
  String get shopItemVoicePackLaconicDesc;

  /// No description provided for @shopItemStickerBalanceSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance sticker set'**
  String get shopItemStickerBalanceSetTitle;

  /// No description provided for @shopItemStickerBalanceSetDesc.
  ///
  /// In en, this message translates to:
  /// **'Tiny stickers for milestones in your assistant scene.'**
  String get shopItemStickerBalanceSetDesc;

  /// No description provided for @shopUseBackground.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get shopUseBackground;

  /// No description provided for @shopBackgroundActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get shopBackgroundActive;

  /// No description provided for @profileBackgroundSection.
  ///
  /// In en, this message translates to:
  /// **'Profile header'**
  String get profileBackgroundSection;

  /// No description provided for @profileAvatarFrameSection.
  ///
  /// In en, this message translates to:
  /// **'Avatar frame'**
  String get profileAvatarFrameSection;

  /// No description provided for @profileNameStyleSection.
  ///
  /// In en, this message translates to:
  /// **'Name style'**
  String get profileNameStyleSection;

  /// No description provided for @profileCosmeticDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get profileCosmeticDefault;

  /// No description provided for @profileLookUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile look updated.'**
  String get profileLookUpdated;

  /// No description provided for @assistantCloseGreenA.
  ///
  /// In en, this message translates to:
  /// **'{streak} green days in a row — that rhythm is real.'**
  String assistantCloseGreenA(int streak);

  /// No description provided for @assistantCloseGreenB.
  ///
  /// In en, this message translates to:
  /// **'You closed with balance. That matters more than a perfect checklist.'**
  String get assistantCloseGreenB;

  /// No description provided for @assistantCloseYellowA.
  ///
  /// In en, this message translates to:
  /// **'Logged an okay day. Tomorrow is a clean page.'**
  String get assistantCloseYellowA;

  /// No description provided for @assistantCloseYellowB.
  ///
  /// In en, this message translates to:
  /// **'Yellow days still count. Rest if your body asks for it.'**
  String get assistantCloseYellowB;

  /// No description provided for @assistantCloseRedA.
  ///
  /// In en, this message translates to:
  /// **'Tough one — you still closed it honestly. That takes guts.'**
  String get assistantCloseRedA;

  /// No description provided for @assistantCloseRedB.
  ///
  /// In en, this message translates to:
  /// **'Red days happen. Be gentle with yourself tonight.'**
  String get assistantCloseRedB;

  /// No description provided for @assistantShopA.
  ///
  /// In en, this message translates to:
  /// **'New sparkle in your collection — enjoy the vibe.'**
  String get assistantShopA;

  /// No description provided for @assistantShopB.
  ///
  /// In en, this message translates to:
  /// **'XP well spent. Treat yourself to the moment.'**
  String get assistantShopB;

  /// No description provided for @assistantGoalDoneA.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal wrapped — that part of life got real attention.'**
  String get assistantGoalDoneA;

  /// No description provided for @assistantGoalDoneB.
  ///
  /// In en, this message translates to:
  /// **'One goal done. Small steps still move mountains.'**
  String get assistantGoalDoneB;

  /// No description provided for @assistantTodayCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance buddy'**
  String get assistantTodayCardTitle;

  /// No description provided for @assistantTodayCardHint.
  ///
  /// In en, this message translates to:
  /// **'One tiny step on your list still counts as forward.'**
  String get assistantTodayCardHint;

  /// No description provided for @assistantTodayBubble.
  ///
  /// In en, this message translates to:
  /// **'Even one small step is a victory!'**
  String get assistantTodayBubble;

  /// No description provided for @assistantWeekBubble.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to open it on Today — your week builds one step at a time.'**
  String get assistantWeekBubble;

  /// No description provided for @assistantRoutineBubble.
  ///
  /// In en, this message translates to:
  /// **'Pick days and times here — routines show up on Today like clockwork.'**
  String get assistantRoutineBubble;

  /// No description provided for @assistantCloseDayBubble.
  ///
  /// In en, this message translates to:
  /// **'A highlight and a reflection — honest words earn you a fair close and XP.'**
  String get assistantCloseDayBubble;

  /// No description provided for @assistantReviewWeekBubble.
  ///
  /// In en, this message translates to:
  /// **'A moment to pause and reflect. Focus on what matters next week.'**
  String get assistantReviewWeekBubble;

  /// No description provided for @assistantScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance buddy'**
  String get assistantScreenTitle;

  /// No description provided for @assistantScreenTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Layers, voice, and shop'**
  String get assistantScreenTileSubtitle;

  /// No description provided for @assistantScreenIntro.
  ///
  /// In en, this message translates to:
  /// **'They show up on Today and chime in when you close the day, buy something, or finish a weekly goal.'**
  String get assistantScreenIntro;

  /// No description provided for @assistantScreenLayersHeading.
  ///
  /// In en, this message translates to:
  /// **'Look layers'**
  String get assistantScreenLayersHeading;

  /// No description provided for @assistantScreenLayersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No layers yet. Open the Shop → Assistant for hats, scarves, and stickers.'**
  String get assistantScreenLayersEmpty;

  /// No description provided for @assistantScreenVoiceHeading.
  ///
  /// In en, this message translates to:
  /// **'How they talk'**
  String get assistantScreenVoiceHeading;

  /// No description provided for @assistantScreenVoiceDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Default voice'**
  String get assistantScreenVoiceDefaultTitle;

  /// No description provided for @assistantScreenVoiceDefault.
  ///
  /// In en, this message translates to:
  /// **'Warm, full sentences.'**
  String get assistantScreenVoiceDefault;

  /// No description provided for @assistantScreenVoiceLaconicLine.
  ///
  /// In en, this message translates to:
  /// **'Laconic pack: short, dry one-liners.'**
  String get assistantScreenVoiceLaconicLine;

  /// No description provided for @assistantOpenShopAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant items in Shop'**
  String get assistantOpenShopAssistant;

  /// No description provided for @assistantLaconicCloseGreenA.
  ///
  /// In en, this message translates to:
  /// **'{streak} green streak. Nice.'**
  String assistantLaconicCloseGreenA(int streak);

  /// No description provided for @assistantLaconicCloseGreenB.
  ///
  /// In en, this message translates to:
  /// **'Balanced close.'**
  String get assistantLaconicCloseGreenB;

  /// No description provided for @assistantLaconicCloseYellowA.
  ///
  /// In en, this message translates to:
  /// **'Okay day. Tomorrow’s open.'**
  String get assistantLaconicCloseYellowA;

  /// No description provided for @assistantLaconicCloseYellowB.
  ///
  /// In en, this message translates to:
  /// **'Yellow still counts.'**
  String get assistantLaconicCloseYellowB;

  /// No description provided for @assistantLaconicCloseRedA.
  ///
  /// In en, this message translates to:
  /// **'Rough day. Logged.'**
  String get assistantLaconicCloseRedA;

  /// No description provided for @assistantLaconicCloseRedB.
  ///
  /// In en, this message translates to:
  /// **'Be easy on yourself.'**
  String get assistantLaconicCloseRedB;

  /// No description provided for @assistantLaconicShopA.
  ///
  /// In en, this message translates to:
  /// **'Nice grab.'**
  String get assistantLaconicShopA;

  /// No description provided for @assistantLaconicShopB.
  ///
  /// In en, this message translates to:
  /// **'Good spend.'**
  String get assistantLaconicShopB;

  /// No description provided for @assistantLaconicGoalA.
  ///
  /// In en, this message translates to:
  /// **'Goal done.'**
  String get assistantLaconicGoalA;

  /// No description provided for @assistantLaconicGoalB.
  ///
  /// In en, this message translates to:
  /// **'Small win.'**
  String get assistantLaconicGoalB;

  /// No description provided for @profileDbBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Local database backup'**
  String get profileDbBackupTitle;

  /// No description provided for @profileDbBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export or replace your on-device SQLite data. Does not include sign-in or notification settings.'**
  String get profileDbBackupSubtitle;

  /// No description provided for @profileDbBackupExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup…'**
  String get profileDbBackupExport;

  /// No description provided for @profileDbBackupImport.
  ///
  /// In en, this message translates to:
  /// **'Restore from file…'**
  String get profileDbBackupImport;

  /// No description provided for @profileDbBackupShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Life Balance database backup'**
  String get profileDbBackupShareSubject;

  /// No description provided for @profileDbBackupExportError.
  ///
  /// In en, this message translates to:
  /// **'Could not export: {message}'**
  String profileDbBackupExportError(String message);

  /// No description provided for @profileDbBackupNotSqlite.
  ///
  /// In en, this message translates to:
  /// **'Choose a valid SQLite file from this app (…sqlite).'**
  String get profileDbBackupNotSqlite;

  /// No description provided for @profileDbBackupImportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace local data?'**
  String get profileDbBackupImportConfirmTitle;

  /// No description provided for @profileDbBackupImportConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All routine, goals, closes, and shop progress on this device will be replaced with the backup. The app will restart.'**
  String get profileDbBackupImportConfirmBody;

  /// No description provided for @profileDbBackupRestart.
  ///
  /// In en, this message translates to:
  /// **'Restore and restart'**
  String get profileDbBackupRestart;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

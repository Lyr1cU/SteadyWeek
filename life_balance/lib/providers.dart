import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/data/day_closure_service.dart';
import 'package:life_balance/domain/day_tier.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/data/goals_repository.dart';
import 'package:life_balance/data/routine_repository.dart';
import 'package:life_balance/data/shop_repository.dart';
import 'package:life_balance/data/weekly_report_repository.dart';
import 'package:life_balance/domain/shop_catalog.dart';
import 'package:life_balance/logic/weekly_report_summary.dart';
import 'package:life_balance/providers/profile_background_provider.dart';
import 'package:life_balance/providers/profile_cosmetics_provider.dart';

export 'package:life_balance/providers/close_day_reminder_provider.dart';
export 'package:life_balance/providers/locale_preference_provider.dart';
export 'package:life_balance/providers/onboarding_provider.dart';
export 'package:life_balance/providers/supabase_provider.dart';
export 'package:life_balance/providers/profile_background_provider.dart';
export 'package:life_balance/providers/profile_cosmetics_provider.dart';
export 'package:life_balance/providers/theme_preference_provider.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(ref.watch(appDatabaseProvider));
});

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepository(ref.watch(appDatabaseProvider));
});

final weeklyReportRepositoryProvider = Provider<WeeklyReportRepository>((ref) {
  return WeeklyReportRepository(ref.watch(appDatabaseProvider));
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository(ref.watch(appDatabaseProvider));
});

final ownedShopItemIdsProvider = StreamProvider<Set<String>>((ref) {
  return ref.watch(shopRepositoryProvider).watchOwnedItemIds();
});

/// Active profile header background shop id, if owned and valid.
final effectiveProfileBackgroundIdProvider = Provider<String?>((ref) {
  final stored = ref.watch(profileBackgroundIdProvider);
  if (stored == null) return null;
  final def = shopItemById(stored);
  if (def == null || def.category != ShopItemCategory.profileBackground) {
    return null;
  }
  final owned = ref.watch(ownedShopItemIdsProvider);
  return owned.when(
    data: (ids) => ids.contains(stored) ? stored : null,
    loading: () => null,
    error: (error, stackTrace) => null,
  );
});

String? _effectiveShopCosmeticId(
  Ref ref,
  String? stored,
  ShopItemCategory category,
) {
  if (stored == null) return null;
  final def = shopItemById(stored);
  if (def == null || def.category != category) return null;
  final owned = ref.watch(ownedShopItemIdsProvider);
  return owned.when(
    data: (ids) => ids.contains(stored) ? stored : null,
    loading: () => null,
    error: (error, stackTrace) => null,
  );
}

final effectiveProfileAvatarFrameIdProvider = Provider<String?>((ref) {
  return _effectiveShopCosmeticId(
    ref,
    ref.watch(profileAvatarFrameIdProvider),
    ShopItemCategory.frame,
  );
});

final effectiveProfileNameStyleIdProvider = Provider<String?>((ref) {
  return _effectiveShopCosmeticId(
    ref,
    ref.watch(profileNameStyleIdProvider),
    ShopItemCategory.nameStyle,
  );
});

/// Owned assistant layer shop ids, in [kShopCatalog] order (cap, scarf, stickers).
final equippedAssistantLayersProvider = Provider<List<String>>((ref) {
  final owned = ref.watch(ownedShopItemIdsProvider);
  return owned.when(
    data: (ids) {
      final out = <String>[];
      for (final item in kShopCatalog) {
        if (item.category == ShopItemCategory.assistantLayer &&
            ids.contains(item.id)) {
          out.add(item.id);
        }
      }
      return out;
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

/// First owned voice pack in catalog order, if any.
final effectiveVoicePackIdProvider = Provider<String?>((ref) {
  final owned = ref.watch(ownedShopItemIdsProvider);
  return owned.when(
    data: (ids) {
      for (final item in kShopCatalog) {
        if (item.category == ShopItemCategory.voicePack &&
            ids.contains(item.id)) {
          return item.id;
        }
      }
      return null;
    },
    loading: () => null,
    error: (error, stackTrace) => null,
  );
});

/// Calendar day shown on the Today tab (local date).
final todayDateProvider = StateProvider<DateTime>((ref) {
  final t = DateTime.now();
  return DateTime(t.year, t.month, t.day);
});

final todayRoutineProvider =
    StreamProvider.autoDispose<List<TodayRoutineRow>>((ref) {
  final repo = ref.watch(routineRepositoryProvider);
  final date = ref.watch(todayDateProvider);
  return repo.watchToday(date);
});

final routineTemplatesProvider =
    StreamProvider.autoDispose<List<RoutineItem>>((ref) {
  return ref.watch(routineRepositoryProvider).watchAllRoutineTemplates();
});

/// Monday of the week currently shown on the Week tab.
final weekPageAnchorProvider = StateProvider<DateTime>((ref) {
  return mondayOfWeekContaining(DateTime.now());
});

final selectedWeekKeyProvider = Provider<String>((ref) {
  return weekKeyFromDate(ref.watch(weekPageAnchorProvider));
});

final weeklyGoalsProvider = StreamProvider.autoDispose<List<WeeklyGoal>>((ref) {
  final key = ref.watch(selectedWeekKeyProvider);
  return ref.watch(goalsRepositoryProvider).watchGoals(key);
});

/// Goals for the calendar week that contains the day shown on Today.
final todayWeekGoalsProvider =
    StreamProvider.autoDispose<List<WeeklyGoal>>((ref) {
  final key = weekKeyFromDate(ref.watch(todayDateProvider));
  return ref.watch(goalsRepositoryProvider).watchGoals(key);
});

final dayClosureServiceProvider = Provider<DayClosureService>((ref) {
  return DayClosureService(ref.watch(appDatabaseProvider));
});

final dailyReportForDayProvider =
    FutureProvider.autoDispose.family<DailyReport?, String>((ref, dayKey) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.dailyReports)..where((t) => t.dayKey.equals(dayKey)))
      .getSingleOrNull();
});

final userStatsProvider = StreamProvider<UserStat?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.userStats)..where((s) => s.id.equals(1)))
      .watch()
      .map((rows) => rows.isEmpty ? null : rows.first);
});

/// [dayKey] → tier for days with a closed report; missing keys are implicitly null.
final weekQualityStripProvider =
    StreamProvider.autoDispose<Map<String, DayTier?>>((ref) {
  final anchor = ref.watch(weekPageAnchorProvider);
  final monday = mondayOfWeekContaining(anchor);
  final keys =
      List.generate(7, (i) => dateKey(monday.add(Duration(days: i))));
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.dailyReports)..where((r) => r.dayKey.isIn(keys));
  return query.watch().map((reports) {
    final out = <String, DayTier?>{for (final k in keys) k: null};
    for (final r in reports) {
      out[r.dayKey] = DayTier.fromStorage(r.dayTier);
    }
    return out;
  });
});

/// Computed stats for Mon–Sun of [weekKey] (Monday `yyyy-MM-dd`).
final weeklyReportSummaryProvider =
    FutureProvider.autoDispose.family<WeeklyReportSummary, String>(
        (ref, weekKey) async {
  final db = ref.watch(appDatabaseProvider);
  final monday = parseDateKeyLocal(weekKey);
  final keys =
      List.generate(7, (i) => dateKey(monday.add(Duration(days: i))));
  final reports =
      await (db.select(db.dailyReports)..where((r) => r.dayKey.isIn(keys)))
          .get();
  final goals = await (db.select(db.weeklyGoals)
        ..where((g) => g.weekKey.equals(weekKey)))
      .get();
  return computeWeeklyReportSummary(
    dayKeysInOrder: keys,
    reportsInWeek: reports,
    goalsForWeek: goals,
  );
});

/// Saved weekly notes row, if any.
final weeklyNotesForWeekProvider =
    StreamProvider.autoDispose.family<WeeklyReport?, String>((ref, weekKey) {
  return ref.watch(weeklyReportRepositoryProvider).watchForWeek(weekKey);
});

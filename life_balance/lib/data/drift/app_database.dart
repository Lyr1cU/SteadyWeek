import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

class RoutineItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get sphere => text()();
  IntColumn get weekdays => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  /// Minutes from midnight (0–1439). Null = no fixed time on the timeline.
  IntColumn get scheduledMinuteOfDay => integer().nullable()();
  IntColumn get effort => integer().withDefault(const Constant(0))();
  BoolColumn get isOptional => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class RoutineDayStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineItemId =>
      integer().references(RoutineItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get dateKey => text()();
  /// 0 = pending, 1 = done, 2 = skipped
  IntColumn get status => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
        {routineItemId, dateKey},
      ];
}

class WeeklyGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get weekKey => text()();
  TextColumn get sphere => text()();
  TextColumn get title => text()();
  IntColumn get targetCount => integer().withDefault(const Constant(1))();
  IntColumn get progressCount => integer().withDefault(const Constant(0))();
  IntColumn get status => integer().withDefault(const Constant(0))();
}

class DailyReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayKey => text().unique()();
  IntColumn get mood => integer().nullable()();
  TextColumn get noteHighlight => text()();
  TextColumn get noteReflection => text()();
  IntColumn get dayTier => integer()();
  IntColumn get xpAwarded => integer()();
  DateTimeColumn get closedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Purchased cosmetic / shop item id (matches [kShopCatalog] ids).
class OwnedShopItems extends Table {
  TextColumn get itemId => text()();
  DateTimeColumn get purchasedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {itemId};
}

/// User weekly reflection; [weekKey] is Monday `yyyy-MM-dd` (same as [WeeklyGoals.weekKey]).
class WeeklyReports extends Table {
  TextColumn get weekKey => text()();
  TextColumn get noteWin => text().withDefault(const Constant(''))();
  TextColumn get noteFocus => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {weekKey};
}

/// Single profile row `id = 1` — XP & streak (MASTER_PLAN §3.1, §8).
class UserStats extends Table {
  IntColumn get id => integer()();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get bestStreak => integer().withDefault(const Constant(0))();
  TextColumn get lastGreenDayKey => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    RoutineItems,
    RoutineDayStates,
    WeeklyGoals,
    DailyReports,
    WeeklyReports,
    OwnedShopItems,
    UserStats,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'life_balance',
      web: kIsWeb
          ? DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            )
          : null,
    );
  }

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedRoutineItems();
          await _seedUserStats();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(dailyReports);
            await m.createTable(userStats);
            await _seedUserStats();
          }
          if (from < 3) {
            await m.addColumn(routineItems, routineItems.scheduledMinuteOfDay);
          }
          if (from < 4) {
            await m.createTable(weeklyReports);
          }
          if (from < 5) {
            await m.createTable(ownedShopItems);
          }
          // Repair: some Web/dev DBs reached user_version 5 without this table.
          if (from < 6) {
            try {
              await m.createTable(ownedShopItems);
            } catch (_) {
              /* table already exists */
            }
          }
        },
      );

  Future<void> _seedUserStats() async {
    await into(userStats).insert(
      UserStatsCompanion.insert(id: const Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> _seedRoutineItems() async {
    await into(routineItems).insert(
      RoutineItemsCompanion.insert(
        title: 'Morning stretch',
        sphere: 'body',
        weekdays: 0x7f,
        sortOrder: const Value(0),
        scheduledMinuteOfDay: const Value(7 * 60 + 30),
      ),
    );
    await into(routineItems).insert(
      RoutineItemsCompanion.insert(
        title: 'Deep work block',
        sphere: 'work',
        weekdays: 0x1f,
        sortOrder: const Value(1),
        scheduledMinuteOfDay: const Value(10 * 60),
      ),
    );
    await into(routineItems).insert(
      RoutineItemsCompanion.insert(
        title: 'Message someone you care about',
        sphere: 'social',
        weekdays: 0x7f,
        sortOrder: const Value(2),
        scheduledMinuteOfDay: const Value(18 * 60 + 30),
      ),
    );
  }
}

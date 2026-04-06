import 'dart:math';

import 'package:drift/drift.dart';
import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/week_key.dart';
import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/data/routine_repository.dart';
import 'package:life_balance/domain/day_tier.dart';
import 'package:life_balance/logic/day_evaluation.dart';
import 'package:life_balance/logic/economy_config.dart';

class CloseDayOutcome {
  const CloseDayOutcome({
    required this.xpAwarded,
    required this.tier,
    required this.newStreak,
    required this.newTotalXp,
  });

  final int xpAwarded;
  final DayTier tier;
  final int newStreak;
  final int newTotalXp;
}

class DayAlreadyClosedException implements Exception {
  const DayAlreadyClosedException();
}

class DayClosureService {
  DayClosureService(this._db);

  final AppDatabase _db;

  Future<DailyReport?> reportFor(String dayKey) async {
    return (_db.select(_db.dailyReports)..where((t) => t.dayKey.equals(dayKey)))
        .getSingleOrNull();
  }

  Future<CloseDayOutcome> submit({
    required DateTime date,
    required String noteHighlight,
    required String noteReflection,
    required int? mood,
  }) async {
    final key = dateKey(date);
    final existing = await reportFor(key);
    if (existing != null) {
      throw const DayAlreadyClosedException();
    }

    final routineRepo = RoutineRepository(_db);
    final rows = await routineRepo.loadTodayRows(date);
    final wk = weekKeyFromDate(date);
    final goals = await (_db.select(_db.weeklyGoals)
          ..where((g) => g.weekKey.equals(wk)))
        .get();

    final evaluation = evaluateDay(
      rows: rows,
      noteHighlight: noteHighlight,
      noteReflection: noteReflection,
      mood: mood,
      weeklyGoals: goals,
    );

    var routineXp = 0;
    for (final r in rows) {
      if (!r.isDone) continue;
      routineXp +=
          xpForEffort(r.item.effort, isOptional: r.item.isOptional);
    }
    routineXp = min(routineXp, routineXpDailyCap);
    final tierBonus = xpTierBonus(evaluation.tier);
    final xpAwarded = routineXp + tierBonus;

    return _db.transaction(() async {
      await _db.into(_db.dailyReports).insert(
            DailyReportsCompanion.insert(
              dayKey: key,
              noteHighlight: noteHighlight,
              noteReflection: noteReflection,
              mood: mood != null ? Value(mood) : const Value.absent(),
              dayTier: evaluation.tier.storageValue,
              xpAwarded: xpAwarded,
            ),
          );

      var stats = await (_db.select(_db.userStats)
            ..where((s) => s.id.equals(1)))
          .getSingleOrNull();
      if (stats == null) {
        await _db
            .into(_db.userStats)
            .insert(UserStatsCompanion.insert(id: const Value(1)));
        stats = await (_db.select(_db.userStats)
              ..where((s) => s.id.equals(1)))
            .getSingle();
      }

      final yKey = dateKey(date.subtract(const Duration(days: 1)));
      final int newStreak;
      final String? newLastGreen;

      if (evaluation.tier == DayTier.green) {
        final chain = stats.lastGreenDayKey == yKey;
        newStreak = chain ? stats.currentStreak + 1 : 1;
        newLastGreen = key;
      } else {
        newStreak = 0;
        newLastGreen = null;
      }

      final newBest = max(stats.bestStreak, newStreak);
      final newTotal = stats.totalXp + xpAwarded;

      await _db.into(_db.userStats).insertOnConflictUpdate(
            UserStatsCompanion(
              id: const Value(1),
              totalXp: Value(newTotal),
              currentStreak: Value(newStreak),
              bestStreak: Value(newBest),
              lastGreenDayKey: Value(newLastGreen),
            ),
          );

      return CloseDayOutcome(
        xpAwarded: xpAwarded,
        tier: evaluation.tier,
        newStreak: newStreak,
        newTotalXp: newTotal,
      );
    });
  }
}

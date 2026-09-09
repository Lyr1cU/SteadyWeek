import 'package:drift/drift.dart';
import 'package:life_balance/data/drift/app_database.dart';

/// Local playtest helpers. Call only from non-release UI (see [ProfileScreen]).
Future<void> debugGrantXp(AppDatabase db, int delta) async {
  if (delta <= 0) return;
  final row = await (db.select(db.userStats)..where((s) => s.id.equals(1)))
      .getSingle();
  await (db.update(db.userStats)..where((s) => s.id.equals(1))).write(
        UserStatsCompanion(totalXp: Value(row.totalXp + delta)),
      );
}

/// Unlocks streak-gated shop items (e.g. Ember frame needs best streak ≥ 7).
Future<void> debugSetBestStreak(AppDatabase db, int bestStreak) async {
  if (bestStreak < 0) return;
  await (db.update(db.userStats)..where((s) => s.id.equals(1))).write(
        UserStatsCompanion(bestStreak: Value(bestStreak)),
      );
}

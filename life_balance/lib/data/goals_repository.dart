import 'package:drift/drift.dart';
import 'package:life_balance/data/drift/app_database.dart';

class GoalsRepository {
  GoalsRepository(this._db);

  final AppDatabase _db;

  Stream<List<WeeklyGoal>> watchGoals(String weekKey) {
    return (_db.select(_db.weeklyGoals)
          ..where((g) => g.weekKey.equals(weekKey))
          ..orderBy([(g) => OrderingTerm.asc(g.id)]))
        .watch();
  }

  Future<int> addGoal({
    required String weekKey,
    required String sphere,
    required String title,
    int targetCount = 1,
  }) {
    final t = targetCount < 1 ? 1 : targetCount;
    return _db.into(_db.weeklyGoals).insert(
          WeeklyGoalsCompanion.insert(
            weekKey: weekKey,
            sphere: sphere,
            title: title,
            targetCount: Value(t),
          ),
        );
  }

  Future<void> bumpProgress(int goalId, int delta) async {
    final row = await (_db.select(_db.weeklyGoals)
          ..where((g) => g.id.equals(goalId)))
        .getSingleOrNull();
    if (row == null) return;
    final next = (row.progressCount + delta).clamp(0, row.targetCount);
    await (_db.update(_db.weeklyGoals)..where((g) => g.id.equals(goalId)))
        .write(
      WeeklyGoalsCompanion(
        progressCount: Value(next),
        status: Value(next >= row.targetCount ? 1 : 0),
      ),
    );
  }

  Future<void> deleteGoal(int id) async {
    await (_db.delete(_db.weeklyGoals)..where((g) => g.id.equals(id))).go();
  }
}

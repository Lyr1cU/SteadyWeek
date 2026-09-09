import 'package:drift/drift.dart';
import 'package:life_balance/data/drift/app_database.dart';

class WeeklyReportRepository {
  WeeklyReportRepository(this._db);

  final AppDatabase _db;

  Stream<WeeklyReport?> watchForWeek(String weekKey) {
    return (_db.select(_db.weeklyReports)
          ..where((w) => w.weekKey.equals(weekKey)))
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<void> saveNotes({
    required String weekKey,
    required String noteWin,
    required String noteFocus,
  }) async {
    await _db.into(_db.weeklyReports).insertOnConflictUpdate(
          WeeklyReportsCompanion.insert(
            weekKey: weekKey,
            noteWin: Value(noteWin),
            noteFocus: Value(noteFocus),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}

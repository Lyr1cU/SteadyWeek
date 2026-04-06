import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';

import 'package:life_balance/core/date_key.dart';
import 'package:life_balance/core/schedule_format.dart';
import 'package:life_balance/data/drift/app_database.dart';

class TodayRoutineRow {
  TodayRoutineRow({required this.item, this.dayState});

  final RoutineItem item;
  final RoutineDayState? dayState;

  bool get isDone => dayState?.status == 1;
  bool get isSkipped => dayState?.status == 2;
}

class RoutineRepository {
  RoutineRepository(this._db);

  final AppDatabase _db;

  /// Emits whenever template items or day rows for [date] change.
  Stream<List<TodayRoutineRow>> watchToday(DateTime date) {
    final controller = StreamController<List<TodayRoutineRow>>(sync: true);
    final key = dateKey(date);
    final wd = date.weekday;

    Future<void> emit() async {
      final items = await _db.select(_db.routineItems).get();
      final forDay =
          items.where((i) => routineRunsOnWeekday(i.weekdays, wd)).toList();
      final states = await (_db.select(_db.routineDayStates)
            ..where((s) => s.dateKey.equals(key)))
          .get();
      final map = {for (final s in states) s.routineItemId: s};
      final rows = forDay
          .map((i) => TodayRoutineRow(item: i, dayState: map[i.id]))
          .toList();
      rows.sort(
        (a, b) => compareRoutineSchedule(
          a.item.scheduledMinuteOfDay,
          a.item.sortOrder,
          b.item.scheduledMinuteOfDay,
          b.item.sortOrder,
        ),
      );
      if (!controller.isClosed) {
        controller.add(rows);
      }
    }

    final sub1 = _db.select(_db.routineItems).watch().listen((_) => emit());
    final sub2 = (_db.select(_db.routineDayStates)
          ..where((s) => s.dateKey.equals(key)))
        .watch()
        .listen((_) => emit());

    controller.onCancel = () {
      sub1.cancel();
      sub2.cancel();
    };

    scheduleMicrotask(() => emit());
    return controller.stream;
  }

  Future<List<TodayRoutineRow>> loadTodayRows(DateTime date) async {
    final key = dateKey(date);
    final wd = date.weekday;
    final items = await _db.select(_db.routineItems).get();
    final forDay =
        items.where((i) => routineRunsOnWeekday(i.weekdays, wd)).toList();
    final states = await (_db.select(_db.routineDayStates)
          ..where((s) => s.dateKey.equals(key)))
        .get();
    final map = {for (final s in states) s.routineItemId: s};
    final rows = forDay
        .map((i) => TodayRoutineRow(item: i, dayState: map[i.id]))
        .toList();
    rows.sort(
      (a, b) => compareRoutineSchedule(
        a.item.scheduledMinuteOfDay,
        a.item.sortOrder,
        b.item.scheduledMinuteOfDay,
        b.item.sortOrder,
      ),
    );
    return rows;
  }

  Future<void> setItemDone({
    required int routineItemId,
    required DateTime date,
    required bool done,
  }) async {
    final key = dateKey(date);
    if (done) {
      await _db.into(_db.routineDayStates).insertOnConflictUpdate(
            RoutineDayStatesCompanion.insert(
              routineItemId: routineItemId,
              dateKey: key,
              status: const Value(1),
            ),
          );
    } else {
      await (_db.delete(_db.routineDayStates)..where(
            (s) =>
                s.routineItemId.equals(routineItemId) & s.dateKey.equals(key),
          ))
          .go();
    }
  }

  /// 0 = pending (removes row), 1 = done, 2 = skipped.
  Future<void> setRoutineDayStatus({
    required int routineItemId,
    required DateTime date,
    required int status,
  }) async {
    final key = dateKey(date);
    if (status == 0) {
      await (_db.delete(_db.routineDayStates)..where(
            (s) =>
                s.routineItemId.equals(routineItemId) & s.dateKey.equals(key),
          ))
          .go();
    } else {
      await _db.into(_db.routineDayStates).insertOnConflictUpdate(
            RoutineDayStatesCompanion.insert(
              routineItemId: routineItemId,
              dateKey: key,
              status: Value(status),
            ),
          );
    }
  }

  Future<int> addRoutineItem({
    required String title,
    required String sphere,
    required int weekdaysMask,
    int? scheduledMinuteOfDay,
  }) async {
    final existing = await _db.select(_db.routineItems).get();
    final nextOrder = existing.isEmpty
        ? 0
        : existing.map((e) => e.sortOrder).reduce(max) + 1;
    return _db.into(_db.routineItems).insert(
          RoutineItemsCompanion.insert(
            title: title,
            sphere: sphere,
            weekdays: weekdaysMask,
            sortOrder: Value(nextOrder),
            scheduledMinuteOfDay: scheduledMinuteOfDay == null
                ? const Value.absent()
                : Value(scheduledMinuteOfDay),
          ),
        );
  }

  Future<void> updateRoutineItem({
    required int id,
    required String title,
    required String sphere,
    required int weekdaysMask,
    int? scheduledMinuteOfDay,
  }) async {
    await (_db.update(_db.routineItems)..where((t) => t.id.equals(id))).write(
          RoutineItemsCompanion(
            title: Value(title),
            sphere: Value(sphere),
            weekdays: Value(weekdaysMask),
            scheduledMinuteOfDay: Value(scheduledMinuteOfDay),
          ),
        );
  }

  Future<void> deleteRoutineItem(int id) async {
    await (_db.delete(_db.routineItems)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<RoutineItem>> watchAllRoutineTemplates() {
    return _db.select(_db.routineItems).watch().map((items) {
      final copy = [...items];
      copy.sort(
        (a, b) => compareRoutineSchedule(
          a.scheduledMinuteOfDay,
          a.sortOrder,
          b.scheduledMinuteOfDay,
          b.sortOrder,
        ),
      );
      return copy;
    });
  }
}

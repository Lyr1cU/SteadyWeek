import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/domain/day_tier.dart';

/// Aggregates for the week view (computed from existing tables).
class WeeklyReportSummary {
  const WeeklyReportSummary({
    required this.greenDays,
    required this.yellowDays,
    required this.redDays,
    required this.daysClosed,
    required this.daysInWeek,
    required this.weekXp,
    required this.goalsCompleted,
    required this.goalsTotal,
  });

  final int greenDays;
  final int yellowDays;
  final int redDays;
  final int daysClosed;
  final int daysInWeek;
  final int weekXp;
  final int goalsCompleted;
  final int goalsTotal;
}

WeeklyReportSummary computeWeeklyReportSummary({
  required List<String> dayKeysInOrder,
  required List<DailyReport> reportsInWeek,
  required List<WeeklyGoal> goalsForWeek,
}) {
  final byKey = {for (final r in reportsInWeek) r.dayKey: r};
  var green = 0;
  var yellow = 0;
  var red = 0;
  var closed = 0;
  var weekXp = 0;
  for (final k in dayKeysInOrder) {
    final rep = byKey[k];
    if (rep == null) continue;
    closed++;
    weekXp += rep.xpAwarded;
    switch (DayTier.fromStorage(rep.dayTier)) {
      case DayTier.green:
        green++;
      case DayTier.yellow:
        yellow++;
      case DayTier.red:
        red++;
    }
  }
  var gc = 0;
  final gt = goalsForWeek.length;
  for (final goal in goalsForWeek) {
    final t = goal.targetCount <= 0 ? 1 : goal.targetCount;
    if (goal.progressCount >= t || goal.status == 1) gc++;
  }
  return WeeklyReportSummary(
    greenDays: green,
    yellowDays: yellow,
    redDays: red,
    daysClosed: closed,
    daysInWeek: dayKeysInOrder.length,
    weekXp: weekXp,
    goalsCompleted: gc,
    goalsTotal: gt,
  );
}

import 'package:life_balance/data/drift/app_database.dart';
import 'package:life_balance/data/routine_repository.dart';
import 'package:life_balance/domain/day_tier.dart';

class DayEvaluation {
  DayEvaluation({
    required this.tier,
    required this.routineCompletionRate,
    required this.distinctSpheres,
    required this.workImbalance,
    required this.reportQualityOk,
  });

  final DayTier tier;
  final double routineCompletionRate;
  final int distinctSpheres;
  final bool workImbalance;
  final bool reportQualityOk;
}

/// MASTER_PLAN §6.1–6.2 (simplified, numbers adjustable).
DayEvaluation evaluateDay({
  required List<TodayRoutineRow> rows,
  required String noteHighlight,
  required String noteReflection,
  required int? mood,
  required List<WeeklyGoal> weeklyGoals,
}) {
  final requiredRows = rows.where((r) => !r.item.isOptional).toList();
  final doneRequired =
      requiredRows.where((r) => r.isDone).length;
  final r = requiredRows.isEmpty
      ? 1.0
      : doneRequired / requiredRows.length;

  final doneRows = rows.where((x) => x.isDone).toList();
  final spheres = doneRows.map((x) => x.item.sphere).toSet();
  final s = spheres.length;

  final workDone =
      doneRows.where((x) => x.item.sphere == 'work').length;
  final restSocialDone = doneRows
      .where((x) {
        final sp = x.item.sphere;
        return sp == 'rest' || sp == 'social';
      })
      .length;
  final hasRestOrSocialGoal = weeklyGoals.any(
    (g) =>
        (g.sphere == 'rest' || g.sphere == 'social') && g.status != 1,
  );
  final workImbalance =
      workDone >= 3 && restSocialDone == 0 && hasRestOrSocialGoal;

  final h = noteHighlight.trim();
  final ref = noteReflection.trim();
  final reportQualityOk =
      (h.length >= 2 && ref.length >= 2) || (mood != null && h.length >= 2);

  DayTier tier;
  if (r >= 0.5 && s >= 2 && !workImbalance && reportQualityOk) {
    tier = DayTier.green;
  } else if (r >= 0.35 || (s >= 2 && !workImbalance)) {
    tier = DayTier.yellow;
  } else {
    tier = DayTier.red;
  }

  return DayEvaluation(
    tier: tier,
    routineCompletionRate: r,
    distinctSpheres: s,
    workImbalance: workImbalance,
    reportQualityOk: reportQualityOk,
  );
}

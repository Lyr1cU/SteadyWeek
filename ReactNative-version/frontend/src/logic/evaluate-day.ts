import type { DayTier } from '../domain/day-tier';
import type { TodayRoutineRow, WeeklyGoal } from '../domain/models';
import { evaluationConfig } from './evaluation-config';

export type DayEvaluation = {
  tier: DayTier;
  routineCompletionRate: number;
  distinctSpheres: number;
  workImbalance: boolean;
  reportQualityOk: boolean;
};

/** Pure. Close-day screen will call this in phase 4 — do not import SQLite here. */
export function evaluateDay(input: {
  rows: TodayRoutineRow[];
  noteHighlight: string;
  noteReflection: string;
  mood: number | null;
  weeklyGoals: WeeklyGoal[];
}): DayEvaluation {
  const { rows, noteHighlight, noteReflection, mood, weeklyGoals } = input;
  const requiredRows = rows.filter((r) => !r.item.isOptional);
  const doneRequired = requiredRows.filter((r) => r.status === 'done').length;
  const r =
    requiredRows.length === 0 ? 1 : doneRequired / requiredRows.length;

  const doneRows = rows.filter((x) => x.status === 'done');
  const spheres = new Set(doneRows.map((x) => x.item.sphere));
  const s = spheres.size;

  const workDone = doneRows.filter((x) => x.item.sphere === 'work').length;
  const restSocialDone = doneRows.filter((x) => {
    const sp = x.item.sphere;
    return sp === 'rest' || sp === 'social';
  }).length;
  const hasRestOrSocialGoal = weeklyGoals.some(
    (g) =>
      (g.sphere === 'rest' || g.sphere === 'social') && g.status !== 'completed',
  );
  const workImbalance =
    workDone >= evaluationConfig.workImbalanceMinWorkDone &&
    restSocialDone === 0 &&
    hasRestOrSocialGoal;

  const h = noteHighlight.trim();
  const ref = noteReflection.trim();
  const reportQualityOk =
    (h.length >= 2 && ref.length >= 2) || (mood != null && h.length >= 2);

  let tier: DayTier;
  if (
    r >= evaluationConfig.greenMinRoutineRate &&
    s >= evaluationConfig.greenMinSpheres &&
    !workImbalance &&
    reportQualityOk
  ) {
    tier = 'green';
  } else if (
    r >= evaluationConfig.yellowMinRoutineRate ||
    (s >= evaluationConfig.greenMinSpheres && !workImbalance)
  ) {
    tier = 'yellow';
  } else {
    tier = 'red';
  }

  return {
    tier,
    routineCompletionRate: r,
    distinctSpheres: s,
    workImbalance,
    reportQualityOk,
  };
}

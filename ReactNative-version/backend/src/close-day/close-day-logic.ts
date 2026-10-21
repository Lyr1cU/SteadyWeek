/** MASTER_PLAN §6.2 — keep in sync with frontend `logic/evaluation-config.ts`. */
export const evaluationConfig = {
  greenMinRoutineRate: 0.5,
  greenMinSpheres: 2,
  yellowMinRoutineRate: 0.35,
  workImbalanceMinWorkDone: 3,
} as const;

export type DayTier = 'green' | 'yellow' | 'red';

export type EvaluateDayInput = {
  rows: Array<{
    status: string;
    isOptional: boolean;
    sphere: string;
    effort: string;
  }>;
  noteHighlight: string;
  noteReflection: string;
  mood: number | null;
  weeklyGoals: Array<{ sphere: string; status: string }>;
};

export function evaluateDay(input: EvaluateDayInput) {
  const { rows, noteHighlight, noteReflection, mood, weeklyGoals } = input;
  const requiredRows = rows.filter((r) => !r.isOptional);
  const doneRequired = requiredRows.filter((r) => r.status === 'done').length;
  const r = requiredRows.length === 0 ? 1 : doneRequired / requiredRows.length;

  const doneRows = rows.filter((x) => x.status === 'done');
  const spheres = new Set(doneRows.map((x) => x.sphere));
  const s = spheres.size;

  const workDone = doneRows.filter((x) => x.sphere === 'work').length;
  const restSocialDone = doneRows.filter((x) => {
    const sp = x.sphere;
    return sp === 'rest' || sp === 'social';
  }).length;
  const hasRestOrSocialGoal = weeklyGoals.some(
    (g) => (g.sphere === 'rest' || g.sphere === 'social') && g.status !== 'completed',
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

export const routineXpDailyCap = 200;

export function xpForEffort(effort: string, isOptional: boolean): number {
  let base = effort === 'medium' ? 8 : effort === 'heavy' ? 12 : 5;
  if (isOptional) {
    base = Math.floor(base / 2);
  }
  return base;
}

export function xpTierBonus(tier: DayTier): number {
  if (tier === 'green') return 25;
  if (tier === 'yellow') return 10;
  return 0;
}

export function xpForClosedDay(
  rows: Array<{ status: string; effort: string; isOptional: boolean }>,
  tier: DayTier,
): number {
  let routineXp = 0;
  for (const row of rows) {
    if (row.status !== 'done') {
      continue;
    }
    routineXp += xpForEffort(row.effort, row.isOptional);
  }
  return Math.min(routineXp, routineXpDailyCap) + xpTierBonus(tier);
}

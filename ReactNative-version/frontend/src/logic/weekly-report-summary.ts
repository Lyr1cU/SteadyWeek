import type { DailyReport, WeeklyGoal } from '../domain/models';

export type WeeklyReportSummary = {
  greenDays: number;
  yellowDays: number;
  redDays: number;
  daysClosed: number;
  daysInWeek: number;
  weekXp: number;
  goalsCompleted: number;
  goalsTotal: number;
};

export function computeWeeklyReportSummary(input: {
  dayKeysInOrder: string[];
  reportsInWeek: DailyReport[];
  goalsForWeek: WeeklyGoal[];
}): WeeklyReportSummary {
  const { dayKeysInOrder, reportsInWeek, goalsForWeek } = input;
  const byKey = new Map(reportsInWeek.map((r) => [r.dayKey, r]));
  let green = 0;
  let yellow = 0;
  let red = 0;
  let closed = 0;
  let weekXp = 0;

  for (const k of dayKeysInOrder) {
    const rep = byKey.get(k);
    if (!rep) {
      continue;
    }
    closed++;
    weekXp += rep.xpAwarded;
    if (rep.dayTier === 'green') {
      green++;
    } else if (rep.dayTier === 'yellow') {
      yellow++;
    } else {
      red++;
    }
  }

  let goalsCompleted = 0;
  const goalsTotal = goalsForWeek.length;
  for (const goal of goalsForWeek) {
    const t = goal.targetCount <= 0 ? 1 : goal.targetCount;
    if (goal.progressCount >= t || goal.status === 'completed') {
      goalsCompleted++;
    }
  }

  return {
    greenDays: green,
    yellowDays: yellow,
    redDays: red,
    daysClosed: closed,
    daysInWeek: dayKeysInOrder.length,
    weekXp,
    goalsCompleted,
    goalsTotal,
  };
}

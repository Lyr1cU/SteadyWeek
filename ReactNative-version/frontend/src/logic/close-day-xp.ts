import type { DayTier } from '../domain/day-tier';
import type { TodayRoutineRow } from '../domain/models';
import { routineXpDailyCap, xpForEffort, xpTierBonus } from './economy';

/** Routine XP (capped) + tier bonus. Pure — no SQLite. */
export function xpForClosedDay(rows: TodayRoutineRow[], tier: DayTier): number {
  let routineXp = 0;
  for (const row of rows) {
    if (row.status !== 'done') {
      continue;
    }
    routineXp += xpForEffort(row.item.effort, row.item.isOptional);
  }
  return Math.min(routineXp, routineXpDailyCap) + xpTierBonus(tier);
}

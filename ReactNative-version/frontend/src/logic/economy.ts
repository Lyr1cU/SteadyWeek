import type { DayTier } from '../domain/day-tier';
import type { Effort } from '../domain/models';

/** MASTER_PLAN §7 — called from close-day in phase 5, not from UI yet. */
export function xpForEffort(effort: Effort, isOptional: boolean): number {
  let base = effort === 'medium' ? 8 : effort === 'heavy' ? 12 : 5;
  if (isOptional) {
    base = Math.floor(base / 2);
  }
  return base;
}

export const routineXpDailyCap = 200;

export function xpTierBonus(tier: DayTier): number {
  if (tier === 'green') return 25;
  if (tier === 'yellow') return 10;
  return 0;
}

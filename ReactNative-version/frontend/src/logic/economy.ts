import type { DayTier } from '../domain/day-tier';
import type { Effort } from '../domain/models';

/** MASTER_PLAN §7 — used when closing the day (XP UI in phase 5). */
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

/** MASTER_PLAN §7 — cosmetic level from lifetime XP. */
export function levelFromTotalXp(totalXp: number): number {
  const safe = Math.max(0, totalXp);
  return Math.floor(Math.sqrt(safe / 100));
}

/** XP still needed to reach the next level (0 if at cap for current total). */
export function xpToNextLevel(totalXp: number): number {
  const level = levelFromTotalXp(totalXp);
  const nextThreshold = (level + 1) ** 2 * 100;
  return Math.max(0, nextThreshold - Math.max(0, totalXp));
}

/** Progress within the current level band, 0…1. */
export function xpProgressInLevel(totalXp: number): number {
  const safe = Math.max(0, totalXp);
  const level = levelFromTotalXp(safe);
  const levelStart = level ** 2 * 100;
  const nextThreshold = (level + 1) ** 2 * 100;
  const span = nextThreshold - levelStart;
  if (span <= 0) {
    return 1;
  }
  return Math.min(1, Math.max(0, (safe - levelStart) / span));
}

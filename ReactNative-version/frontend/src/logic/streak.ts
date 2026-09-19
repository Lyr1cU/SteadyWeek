/**
 * Огонёк = подряд закрытые календарные дни (любой тир).
 * MASTER_PLAN §6.3 / §8.1. Колонка БД `last_green_day_key` = последний закрытый день.
 */
export type StreakState = {
  currentStreak: number;
  lastGreenDayKey: string | null;
};

export function nextStreakAfterClose(input: {
  dayKey: string;
  yesterdayKey: string;
  currentStreak: number;
  lastGreenDayKey: string | null;
}): StreakState {
  const chained = input.lastGreenDayKey === input.yesterdayKey;
  return {
    currentStreak: chained ? input.currentStreak + 1 : 1,
    lastGreenDayKey: input.dayKey,
  };
}

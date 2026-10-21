import { addDays, formatDayKey } from '../common/calendar';
import { parseDayKey } from '../assistant/weekdays';

export type StreakState = {
  currentStreak: number;
  lastGreenDayKey: string | null;
};

const DAY_KEY = /^\d{4}-\d{2}-\d{2}$/;

/** Matches frontend `logic/streak.ts`. */
export function computeStreakFromClosedDayKeys(closedDayKeys: readonly string[]): StreakState {
  const unique = [...new Set(closedDayKeys.filter((key) => DAY_KEY.test(key)))].sort();
  if (unique.length === 0) {
    return { currentStreak: 0, lastGreenDayKey: null };
  }

  const lastGreenDayKey = unique[unique.length - 1];
  let currentStreak = 1;
  for (let i = unique.length - 1; i > 0; i -= 1) {
    const expectedPrev = formatDayKey(addDays(parseDayKey(unique[i]), -1));
    if (unique[i - 1] !== expectedPrev) {
      break;
    }
    currentStreak += 1;
  }

  return { currentStreak, lastGreenDayKey };
}

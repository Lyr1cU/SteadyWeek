import type { DayTier } from '../../domain/day-tier';
import type { DailyReport } from '../../domain/models';

export class DayAlreadyClosedError extends Error {
  constructor(dayKey: string) {
    super(`Day already closed: ${dayKey}`);
    this.name = 'DayAlreadyClosedError';
  }
}

export class FutureDayCloseError extends Error {
  constructor(dayKey: string) {
    super(`Cannot close a future day: ${dayKey}`);
    this.name = 'FutureDayCloseError';
  }
}

export type CloseDayOutcome = {
  xpAwarded: number;
  tier: DayTier;
  newStreak: number;
  newTotalXp: number;
  report: DailyReport;
};

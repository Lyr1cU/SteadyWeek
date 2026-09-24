import type { DailyReport } from '../domain/models';
import { addLocalDays, dateKey, localDayFromKey } from './calendar';
import { streakWarnThreshold, streakWarningWindowDays } from './streak-warning-config';

export type WarningReportSlice = Pick<DailyReport, 'dayKey' | 'dayTier' | 'workImbalance'>;

/** MASTER_PLAN §8.2 — points per closed day in the window. */
export function warningPointsForReport(report: Pick<DailyReport, 'dayTier' | 'workImbalance'>): 0 | 1 {
  if (report.dayTier === 'red') {
    return 1;
  }
  if (report.dayTier === 'yellow' && report.workImbalance) {
    return 1;
  }
  return 0;
}

export function warningWindowDayKeys(anchorDayKey: string): { startKey: string; endKey: string } {
  const anchor = localDayFromKey(anchorDayKey);
  const start = addLocalDays(anchor, -(streakWarningWindowDays - 1));
  return { startKey: dateKey(start), endKey: anchorDayKey };
}

export function countWarningsInWindow(reports: WarningReportSlice[], anchorDayKey: string): number {
  const { startKey, endKey } = warningWindowDayKeys(anchorDayKey);
  let total = 0;
  for (const report of reports) {
    if (report.dayKey < startKey || report.dayKey > endKey) {
      continue;
    }
    total += warningPointsForReport(report);
  }
  return total;
}

export function shouldShowAssistantNudge(warnCount: number): boolean {
  return warnCount >= streakWarnThreshold;
}

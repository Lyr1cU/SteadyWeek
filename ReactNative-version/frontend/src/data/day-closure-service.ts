import type { SQLiteDatabase } from 'expo-sqlite';
import type { DayTier } from '../domain/day-tier';
import type { DailyReport } from '../domain/models';
import { dateKey, weekKeyFromDate } from '../logic/calendar';
import { xpForClosedDay } from '../logic/close-day-xp';
import { evaluateDay } from '../logic/evaluate-day';
import { computeStreakFromClosedDayKeys } from '../logic/streak';
import { createSqliteGoalsRepository } from './sqlite/goals-repository';
import { createSqliteRoutineRepository } from './sqlite/routine-repository';

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

const HIGHLIGHT_MAX = 2000;
const REFLECTION_MAX = 4000;

function clampMood(mood: number | null): number | null {
  if (mood == null) {
    return null;
  }
  if (!Number.isInteger(mood) || mood < 1 || mood > 5) {
    return null;
  }
  return mood;
}

export function createDayClosureService(db: SQLiteDatabase) {
  const routine = createSqliteRoutineRepository(db);
  const goals = createSqliteGoalsRepository(db);

  return {
    async submit(input: {
      date: Date;
      noteHighlight: string;
      noteReflection: string;
      mood: number | null;
    }): Promise<CloseDayOutcome> {
      const key = dateKey(input.date);
      const todayKey = dateKey(new Date());
      if (key > todayKey) {
        throw new FutureDayCloseError(key);
      }

      const mood = clampMood(input.mood);
      const noteHighlight = input.noteHighlight.trim().slice(0, HIGHLIGHT_MAX);
      const noteReflection = input.noteReflection.trim().slice(0, REFLECTION_MAX);

      const rows = await routine.loadTodayRows(input.date);
      const weeklyGoals = await goals.listForWeek(weekKeyFromDate(input.date));

      const evaluation = evaluateDay({
        rows,
        noteHighlight,
        noteReflection,
        mood,
        weeklyGoals,
      });
      const xpAwarded = xpForClosedDay(rows, evaluation.tier);

      let outcome: CloseDayOutcome | null = null;

      await db.withTransactionAsync(async () => {
        const existing = await db.getFirstAsync<{ day_key: string }>(
          'SELECT day_key FROM daily_reports WHERE day_key = ?',
          key,
        );
        if (existing) {
          throw new DayAlreadyClosedError(key);
        }

        const closedAt = new Date().toISOString();

        await db.runAsync(
          `INSERT INTO daily_reports (
            day_key, mood, note_highlight, note_reflection, day_tier, xp_awarded,
            work_imbalance, closed_at, updated_at, pending_sync
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)`,
          key,
          mood,
          noteHighlight,
          noteReflection,
          evaluation.tier,
          xpAwarded,
          evaluation.workImbalance ? 1 : 0,
          closedAt,
          closedAt,
        );

        const statsRow = await db.getFirstAsync<{
          total_xp: number;
          current_streak: number;
          best_streak: number;
          last_green_day_key: string | null;
        }>('SELECT total_xp, current_streak, best_streak, last_green_day_key FROM user_stats WHERE id = 1');

        const stats = statsRow ?? {
          total_xp: 0,
          current_streak: 0,
          best_streak: 0,
          last_green_day_key: null as string | null,
        };

        const closedRows = await db.getAllAsync<{ day_key: string }>(
          'SELECT day_key FROM daily_reports',
        );
        const streak = computeStreakFromClosedDayKeys(closedRows.map((row) => row.day_key));
        const newBest = Math.max(stats.best_streak, streak.currentStreak);
        const newTotal = stats.total_xp + xpAwarded;
        const statsUpdatedAt = new Date().toISOString();

        await db.runAsync(
          `UPDATE user_stats SET
            total_xp = ?, current_streak = ?, best_streak = ?,
            last_green_day_key = ?, updated_at = ?, pending_sync = 1
           WHERE id = 1`,
          newTotal,
          streak.currentStreak,
          newBest,
          streak.lastGreenDayKey,
          statsUpdatedAt,
        );

        outcome = {
          xpAwarded,
          tier: evaluation.tier,
          newStreak: streak.currentStreak,
          newTotalXp: newTotal,
          report: {
            dayKey: key,
            mood,
            noteHighlight,
            noteReflection,
            dayTier: evaluation.tier,
            xpAwarded,
            workImbalance: evaluation.workImbalance,
            closedAt,
          },
        };
      });

      if (!outcome) {
        throw new Error('Close day failed');
      }
      return outcome;
    },
  };
}

export type DayClosureService = ReturnType<typeof createDayClosureService>;

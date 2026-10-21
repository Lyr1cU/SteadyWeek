import type { SQLiteDatabase } from 'expo-sqlite';
import type { DayTier } from '../../domain/day-tier';
import { computeStreakFromClosedDayKeys } from '../../logic/streak';
import { DayAlreadyClosedError, type CloseDayOutcome } from './close-day-errors';

export async function persistClosedDay(
  db: SQLiteDatabase,
  input: {
    dayKey: string;
    mood: number | null;
    noteHighlight: string;
    noteReflection: string;
    tier: DayTier;
    xpAwarded: number;
    workImbalance: boolean;
  },
): Promise<CloseDayOutcome> {
  let outcome: CloseDayOutcome | null = null;

  await db.withTransactionAsync(async () => {
    const existing = await db.getFirstAsync<{ day_key: string }>(
      'SELECT day_key FROM daily_reports WHERE day_key = ?',
      input.dayKey,
    );
    if (existing) {
      throw new DayAlreadyClosedError(input.dayKey);
    }

    const closedAt = new Date().toISOString();
    await insertDailyReport(db, input, closedAt);

    const stats = await readStats(db);
    const closedRows = await db.getAllAsync<{ day_key: string }>(
      'SELECT day_key FROM daily_reports',
    );
    const streak = computeStreakFromClosedDayKeys(closedRows.map((row) => row.day_key));
    const newBest = Math.max(stats.best_streak, streak.currentStreak);
    const newTotal = stats.total_xp + input.xpAwarded;
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
      xpAwarded: input.xpAwarded,
      tier: input.tier,
      newStreak: streak.currentStreak,
      newTotalXp: newTotal,
      report: {
        dayKey: input.dayKey,
        mood: input.mood,
        noteHighlight: input.noteHighlight,
        noteReflection: input.noteReflection,
        dayTier: input.tier,
        xpAwarded: input.xpAwarded,
        workImbalance: input.workImbalance,
        closedAt,
      },
    };
  });

  if (!outcome) {
    throw new Error('Close day failed');
  }
  return outcome;
}

async function insertDailyReport(
  db: SQLiteDatabase,
  input: {
    dayKey: string;
    mood: number | null;
    noteHighlight: string;
    noteReflection: string;
    tier: DayTier;
    xpAwarded: number;
    workImbalance: boolean;
  },
  closedAt: string,
): Promise<void> {
  await db.runAsync(
    `INSERT INTO daily_reports (
      day_key, mood, note_highlight, note_reflection, day_tier, xp_awarded,
      work_imbalance, closed_at, updated_at, pending_sync
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)`,
    input.dayKey,
    input.mood,
    input.noteHighlight,
    input.noteReflection,
    input.tier,
    input.xpAwarded,
    input.workImbalance ? 1 : 0,
    closedAt,
    closedAt,
  );
}

async function readStats(db: SQLiteDatabase): Promise<{
  total_xp: number;
  current_streak: number;
  best_streak: number;
  last_green_day_key: string | null;
}> {
  const statsRow = await db.getFirstAsync<{
    total_xp: number;
    current_streak: number;
    best_streak: number;
    last_green_day_key: string | null;
  }>('SELECT total_xp, current_streak, best_streak, last_green_day_key FROM user_stats WHERE id = 1');

  return (
    statsRow ?? {
      total_xp: 0,
      current_streak: 0,
      best_streak: 0,
      last_green_day_key: null,
    }
  );
}

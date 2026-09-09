import type { SQLiteDatabase } from 'expo-sqlite';
import type { StatsRepository } from '../ports';

export function createSqliteStatsRepository(db: SQLiteDatabase): StatsRepository {
  return {
    async get() {
      const row = await db.getFirstAsync<{
        total_xp: number;
        current_streak: number;
        best_streak: number;
        last_green_day_key: string | null;
      }>('SELECT total_xp, current_streak, best_streak, last_green_day_key FROM user_stats WHERE id = 1');

      return {
        totalXp: row?.total_xp ?? 0,
        currentStreak: row?.current_streak ?? 0,
        bestStreak: row?.best_streak ?? 0,
        lastGreenDayKey: row?.last_green_day_key ?? null,
      };
    },
  };
}

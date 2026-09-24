import type { SQLiteDatabase } from 'expo-sqlite';
import type { DayTier } from '../../domain/day-tier';
import type { DailyReport, WeeklyReport } from '../../domain/models';
import { DAY_TIERS } from '../../domain/day-tier';

type ReportRow = {
  day_key: string;
  mood: number | null;
  note_highlight: string;
  note_reflection: string;
  day_tier: string;
  xp_awarded: number;
  work_imbalance: number;
  closed_at: string;
};

type WeeklyReportRow = {
  week_key: string;
  note_win: string;
  note_focus: string;
  updated_at: string;
};

function mapDayTier(value: string): DayTier {
  if ((DAY_TIERS as readonly string[]).includes(value)) {
    return value as DayTier;
  }
  return 'red';
}

function mapDailyRow(row: ReportRow): DailyReport {
  return {
    dayKey: row.day_key,
    mood: row.mood,
    noteHighlight: row.note_highlight,
    noteReflection: row.note_reflection,
    dayTier: mapDayTier(row.day_tier),
    xpAwarded: row.xp_awarded,
    workImbalance: row.work_imbalance === 1,
    closedAt: row.closed_at,
  };
}

const DAILY_SELECT = `SELECT day_key, mood, note_highlight, note_reflection, day_tier, xp_awarded,
  work_imbalance, closed_at FROM daily_reports`;

export function createSqliteReportsRepository(db: SQLiteDatabase) {
  return {
    async getDaily(dayKey: string): Promise<DailyReport | null> {
      const row = await db.getFirstAsync<ReportRow>(`${DAILY_SELECT} WHERE day_key = ?`, dayKey);
      return row ? mapDailyRow(row) : null;
    },

    async listDailyInWeek(weekKey: string, dayKeys: string[]): Promise<DailyReport[]> {
      if (dayKeys.length === 0) {
        return [];
      }
      const placeholders = dayKeys.map(() => '?').join(', ');
      const rows = await db.getAllAsync<ReportRow>(
        `${DAILY_SELECT} WHERE day_key IN (${placeholders})`,
        ...dayKeys,
      );
      return rows.map(mapDailyRow);
    },

    async listDailyInDayKeyRange(startKey: string, endKey: string): Promise<DailyReport[]> {
      const rows = await db.getAllAsync<ReportRow>(
        `${DAILY_SELECT} WHERE day_key >= ? AND day_key <= ? ORDER BY day_key ASC`,
        startKey,
        endKey,
      );
      return rows.map(mapDailyRow);
    },

    async getWeekly(weekKey: string): Promise<WeeklyReport | null> {
      const row = await db.getFirstAsync<WeeklyReportRow>(
        'SELECT week_key, note_win, note_focus, updated_at FROM weekly_reports WHERE week_key = ?',
        weekKey,
      );
      if (!row) {
        return null;
      }
      return {
        weekKey: row.week_key,
        noteWin: row.note_win,
        noteFocus: row.note_focus,
        updatedAt: row.updated_at,
      };
    },

    async saveWeeklyNotes(weekKey: string, noteWin: string, noteFocus: string): Promise<WeeklyReport> {
      const updatedAt = new Date().toISOString();
      const win = noteWin.trim().slice(0, 4000);
      const focus = noteFocus.trim().slice(0, 4000);
      await db.runAsync(
        `INSERT INTO weekly_reports (week_key, note_win, note_focus, updated_at, pending_sync)
         VALUES (?, ?, ?, ?, 1)
         ON CONFLICT(week_key) DO UPDATE SET
           note_win = excluded.note_win,
           note_focus = excluded.note_focus,
           updated_at = excluded.updated_at,
           pending_sync = 1`,
        weekKey,
        win,
        focus,
        updatedAt,
      );
      return { weekKey, noteWin: win, noteFocus: focus, updatedAt };
    },
  };
}

export type SqliteReportsRepository = ReturnType<typeof createSqliteReportsRepository>;

import type { SQLiteDatabase } from 'expo-sqlite';
import type { PushPayload, SyncRoutineRow } from './sync-types';

type SyncDayRow = {
  day_key: string;
  routine_item_id: string;
  status: string;
  updated_at: string;
};

type SyncSettingRow = {
  key: string;
  value: string;
  updated_at: string;
};

type SyncStatsRow = {
  total_xp: number;
  current_streak: number;
  best_streak: number;
  last_green_day_key: string | null;
  updated_at: string;
};

export async function collectPending(db: SQLiteDatabase): Promise<PushPayload> {
  const routineRows = await db.getAllAsync<SyncRoutineRow>(
    `SELECT id, title, sphere, weekdays, sort_order, effort, is_optional,
            scheduled_minute_of_day, created_at, updated_at, deleted_at
     FROM routine_items WHERE pending_sync = 1`,
  );

  const dayRows = await db.getAllAsync<SyncDayRow>(
    `SELECT day_key, routine_item_id, status, updated_at
     FROM day_item_status WHERE pending_sync = 1`,
  );

  const settingRows = await db.getAllAsync<SyncSettingRow>(
    `SELECT key, value, updated_at FROM app_settings WHERE pending_sync = 1`,
  );

  const statsRow = await db.getFirstAsync<SyncStatsRow>(
    `SELECT total_xp, current_streak, best_streak, last_green_day_key, updated_at
     FROM user_stats WHERE id = 1 AND pending_sync = 1`,
  );

  return {
    routineItems: routineRows.map((row) => ({
      id: row.id,
      title: row.title,
      sphere: row.sphere,
      weekdays: row.weekdays,
      sortOrder: row.sort_order,
      effort: row.effort,
      isOptional: row.is_optional === 1,
      scheduledMinuteOfDay: row.scheduled_minute_of_day,
      createdAt: row.created_at,
      updatedAt: row.updated_at,
      deletedAt: row.deleted_at,
    })),
    dayItemStatus: dayRows.map((row) => ({
      dayKey: row.day_key,
      routineItemId: row.routine_item_id,
      status: row.status,
      updatedAt: row.updated_at,
    })),
    appSettings: settingRows.map((row) => ({
      key: row.key,
      value: row.value,
      updatedAt: row.updated_at,
    })),
    userStats: statsRow
      ? {
          totalXp: statsRow.total_xp,
          currentStreak: statsRow.current_streak,
          bestStreak: statsRow.best_streak,
          lastGreenDayKey: statsRow.last_green_day_key,
          updatedAt: statsRow.updated_at ?? new Date().toISOString(),
        }
      : null,
  };
}

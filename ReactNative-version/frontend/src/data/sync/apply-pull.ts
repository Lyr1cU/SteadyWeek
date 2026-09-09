import type { SQLiteDatabase } from 'expo-sqlite';
import type { PullResponse } from './sync-types';

export async function applyPull(db: SQLiteDatabase, pull: PullResponse): Promise<void> {
  await db.withTransactionAsync(async () => {
    for (const item of pull.routineItems) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM routine_items WHERE id = ?',
        item.id,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > item.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO routine_items (
          id, title, sphere, weekdays, sort_order, effort, is_optional,
          scheduled_minute_of_day, created_at, updated_at, deleted_at, pending_sync
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)
        ON CONFLICT(id) DO UPDATE SET
          title = excluded.title,
          sphere = excluded.sphere,
          weekdays = excluded.weekdays,
          sort_order = excluded.sort_order,
          effort = excluded.effort,
          is_optional = excluded.is_optional,
          scheduled_minute_of_day = excluded.scheduled_minute_of_day,
          updated_at = excluded.updated_at,
          deleted_at = excluded.deleted_at,
          pending_sync = 0`,
        item.id,
        item.title,
        item.sphere,
        item.weekdays,
        item.sortOrder,
        item.effort,
        item.isOptional ? 1 : 0,
        item.scheduledMinuteOfDay,
        item.createdAt,
        item.updatedAt,
        item.deletedAt,
      );
    }

    for (const row of pull.dayItemStatus) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        `SELECT updated_at, pending_sync FROM day_item_status
         WHERE day_key = ? AND routine_item_id = ?`,
        row.dayKey,
        row.routineItemId,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > row.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO day_item_status (day_key, routine_item_id, status, updated_at, pending_sync)
         VALUES (?, ?, ?, ?, 0)
         ON CONFLICT(day_key, routine_item_id) DO UPDATE SET
           status = excluded.status,
           updated_at = excluded.updated_at,
           pending_sync = 0`,
        row.dayKey,
        row.routineItemId,
        row.status,
        row.updatedAt,
      );
    }

    for (const row of pull.appSettings) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM app_settings WHERE key = ?',
        row.key,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > row.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO app_settings (key, value, updated_at, pending_sync)
         VALUES (?, ?, ?, 0)
         ON CONFLICT(key) DO UPDATE SET
           value = excluded.value,
           updated_at = excluded.updated_at,
           pending_sync = 0`,
        row.key,
        row.value,
        row.updatedAt,
      );
    }

    if (pull.userStats) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM user_stats WHERE id = 1',
      );
      if (local?.pending_sync !== 1 && !(local && local.updated_at > pull.userStats.updatedAt)) {
        await db.runAsync(
          `UPDATE user_stats SET
            total_xp = ?, current_streak = ?, best_streak = ?,
            last_green_day_key = ?, updated_at = ?, pending_sync = 0
           WHERE id = 1`,
          pull.userStats.totalXp,
          pull.userStats.currentStreak,
          pull.userStats.bestStreak,
          pull.userStats.lastGreenDayKey,
          pull.userStats.updatedAt,
        );
      }
    }
  });
}

/** Restore from cloud: drop local schedule, then apply the full pull. Keeps onboarding flag. */
export async function replaceScheduleFromPull(db: SQLiteDatabase, pull: PullResponse): Promise<void> {
  await db.execAsync(`
    DELETE FROM day_item_status;
    DELETE FROM routine_items;
  `);
  await applyPull(db, pull);
}

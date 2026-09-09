import type { SQLiteDatabase } from 'expo-sqlite';
import type { PushPayload } from './sync-types';

/** Clear pending only if the row was not edited again while the push was in flight. */
export async function clearPendingFlags(db: SQLiteDatabase, payload: PushPayload): Promise<void> {
  for (const item of payload.routineItems) {
    await db.runAsync(
      'UPDATE routine_items SET pending_sync = 0 WHERE id = ? AND updated_at = ?',
      item.id,
      item.updatedAt,
    );
  }
  for (const row of payload.dayItemStatus) {
    await db.runAsync(
      `UPDATE day_item_status SET pending_sync = 0
       WHERE day_key = ? AND routine_item_id = ? AND updated_at = ?`,
      row.dayKey,
      row.routineItemId,
      row.updatedAt,
    );
  }
  for (const row of payload.appSettings) {
    await db.runAsync(
      'UPDATE app_settings SET pending_sync = 0 WHERE key = ? AND updated_at = ?',
      row.key,
      row.updatedAt,
    );
  }
  if (payload.userStats) {
    await db.runAsync(
      'UPDATE user_stats SET pending_sync = 0 WHERE id = 1 AND updated_at = ?',
      payload.userStats.updatedAt,
    );
  }
}

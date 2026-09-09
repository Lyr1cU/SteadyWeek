import type { SQLiteDatabase } from 'expo-sqlite';

const LAST_PULL_KEY = 'last_pull_at';
const SYNC_USER_KEY = 'sync_user_id';

export async function getSyncMeta(db: SQLiteDatabase, key: string): Promise<string | null> {
  const row = await db.getFirstAsync<{ value: string }>(
    'SELECT value FROM sync_meta WHERE key = ?',
    key,
  );
  return row?.value ?? null;
}

export async function setSyncMeta(db: SQLiteDatabase, key: string, value: string): Promise<void> {
  await db.runAsync(
    `INSERT INTO sync_meta (key, value) VALUES (?, ?)
     ON CONFLICT(key) DO UPDATE SET value = excluded.value`,
    key,
    value,
  );
}

export async function getLastPullAt(db: SQLiteDatabase): Promise<string> {
  return (await getSyncMeta(db, LAST_PULL_KEY)) ?? new Date(0).toISOString();
}

export async function setLastPullAt(db: SQLiteDatabase, value: string): Promise<void> {
  await setSyncMeta(db, LAST_PULL_KEY, value);
}

export async function markAllPending(db: SQLiteDatabase): Promise<void> {
  await db.execAsync(`
    UPDATE routine_items SET pending_sync = 1;
    UPDATE day_item_status SET pending_sync = 1;
    UPDATE app_settings SET pending_sync = 1;
    UPDATE user_stats SET pending_sync = 1;
  `);
}

export async function getSyncedUserId(db: SQLiteDatabase): Promise<string | null> {
  return getSyncMeta(db, SYNC_USER_KEY);
}

export async function setSyncedUserId(db: SQLiteDatabase, userId: string): Promise<void> {
  await setSyncMeta(db, SYNC_USER_KEY, userId);
}

export async function resetPullCursor(db: SQLiteDatabase): Promise<void> {
  await setLastPullAt(db, new Date(0).toISOString());
}

/** Drop local schedule when another account signs in. Keeps onboarding. */
export async function wipeLocalSchedule(db: SQLiteDatabase): Promise<void> {
  await db.execAsync(`
    DELETE FROM day_item_status;
    DELETE FROM routine_items;
  `);
  await resetPullCursor(db);
}

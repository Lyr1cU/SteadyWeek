import type { SQLiteDatabase } from 'expo-sqlite';

type ColumnRow = { name: string };

async function hasColumn(db: SQLiteDatabase, table: string, column: string): Promise<boolean> {
  const rows = await db.getAllAsync<ColumnRow>(`PRAGMA table_info(${table})`);
  return rows.some((row) => row.name === column);
}

async function addColumnIfMissing(
  db: SQLiteDatabase,
  table: string,
  column: string,
  definition: string,
): Promise<void> {
  if (!(await hasColumn(db, table, column))) {
    await db.execAsync(`ALTER TABLE ${table} ADD COLUMN ${column} ${definition}`);
  }
}

/** Phase 2: pending_sync flags + sync_meta cursor. Safe to run multiple times. */
export async function migrateSyncSchema(db: SQLiteDatabase): Promise<void> {
  await db.execAsync(`
    CREATE TABLE IF NOT EXISTS sync_meta (
      key TEXT PRIMARY KEY NOT NULL,
      value TEXT NOT NULL
    );
  `);

  await addColumnIfMissing(db, 'routine_items', 'pending_sync', 'INTEGER NOT NULL DEFAULT 0');
  await addColumnIfMissing(db, 'day_item_status', 'pending_sync', 'INTEGER NOT NULL DEFAULT 0');
  await addColumnIfMissing(db, 'app_settings', 'pending_sync', 'INTEGER NOT NULL DEFAULT 0');
  await addColumnIfMissing(db, 'user_stats', 'updated_at', 'TEXT');
  await addColumnIfMissing(db, 'user_stats', 'pending_sync', 'INTEGER NOT NULL DEFAULT 0');

  const statsUpdated = await db.getFirstAsync<{ updated_at: string | null }>(
    'SELECT updated_at FROM user_stats WHERE id = 1',
  );
  if (statsUpdated?.updated_at == null) {
    await db.runAsync('UPDATE user_stats SET updated_at = ? WHERE id = 1', new Date().toISOString());
  }
}

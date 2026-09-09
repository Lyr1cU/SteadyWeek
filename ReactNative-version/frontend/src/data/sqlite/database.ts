import * as SQLite from 'expo-sqlite';
import type { SQLiteDatabase } from 'expo-sqlite';
import { DEFAULT_ROUTINE_SEED } from '../seed/default-routine';
import { newRoutineId } from './routine-mapper';
import { migrateSyncSchema } from './sync-migration';

let dbPromise: Promise<SQLiteDatabase> | null = null;

export function getDatabase(): Promise<SQLiteDatabase> {
  if (!dbPromise) {
    dbPromise = openAndMigrate();
  }
  return dbPromise;
}

async function openAndMigrate(): Promise<SQLiteDatabase> {
  const db = await SQLite.openDatabaseAsync('steadyweek.db');
  await db.execAsync(`
    PRAGMA journal_mode = WAL;

    CREATE TABLE IF NOT EXISTS routine_items (
      id TEXT PRIMARY KEY NOT NULL,
      title TEXT NOT NULL,
      sphere TEXT NOT NULL,
      weekdays INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      effort TEXT NOT NULL,
      is_optional INTEGER NOT NULL DEFAULT 0,
      scheduled_minute_of_day INTEGER,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      deleted_at TEXT
    );

    CREATE TABLE IF NOT EXISTS day_item_status (
      day_key TEXT NOT NULL,
      routine_item_id TEXT NOT NULL,
      status TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      PRIMARY KEY (day_key, routine_item_id)
    );

    CREATE TABLE IF NOT EXISTS user_stats (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      total_xp INTEGER NOT NULL DEFAULT 0,
      current_streak INTEGER NOT NULL DEFAULT 0,
      best_streak INTEGER NOT NULL DEFAULT 0,
      last_green_day_key TEXT
    );

    CREATE TABLE IF NOT EXISTS app_settings (
      key TEXT PRIMARY KEY NOT NULL,
      value TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );

    INSERT OR IGNORE INTO user_stats (id) VALUES (1);
  `);

  const count = await db.getFirstAsync<{ n: number }>(
    'SELECT COUNT(*) AS n FROM routine_items WHERE deleted_at IS NULL',
  );
  if ((count?.n ?? 0) === 0) {
    await seedRoutine(db);
  }

  await migrateSyncSchema(db);

  return db;
}

async function seedRoutine(db: SQLiteDatabase): Promise<void> {
  const now = new Date().toISOString();
  for (const item of DEFAULT_ROUTINE_SEED) {
    await db.runAsync(
      `INSERT INTO routine_items (
        id, title, sphere, weekdays, sort_order, effort,
        is_optional, scheduled_minute_of_day, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      newRoutineId(),
      item.title,
      item.sphere,
      item.weekdays,
      item.order,
      item.effort,
      item.isOptional ? 1 : 0,
      item.scheduledMinuteOfDay,
      now,
      now,
    );
  }
}

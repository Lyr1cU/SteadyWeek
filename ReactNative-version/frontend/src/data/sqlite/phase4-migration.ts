import type { SQLiteDatabase } from 'expo-sqlite';

/** Phase 4: weekly goals, daily/weekly reports + pending_sync. Safe to run multiple times. */
export async function migratePhase4Schema(db: SQLiteDatabase): Promise<void> {
  await db.execAsync(`
    CREATE TABLE IF NOT EXISTS weekly_goals (
      id TEXT PRIMARY KEY NOT NULL,
      week_key TEXT NOT NULL,
      sphere TEXT NOT NULL,
      title TEXT NOT NULL,
      target_count INTEGER NOT NULL DEFAULT 1,
      progress_count INTEGER NOT NULL DEFAULT 0,
      status TEXT NOT NULL DEFAULT 'active',
      updated_at TEXT NOT NULL,
      deleted_at TEXT,
      pending_sync INTEGER NOT NULL DEFAULT 0
    );

    CREATE TABLE IF NOT EXISTS daily_reports (
      day_key TEXT PRIMARY KEY NOT NULL,
      mood INTEGER,
      note_highlight TEXT NOT NULL DEFAULT '',
      note_reflection TEXT NOT NULL DEFAULT '',
      day_tier TEXT NOT NULL,
      xp_awarded INTEGER NOT NULL DEFAULT 0,
      closed_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      pending_sync INTEGER NOT NULL DEFAULT 0
    );

    CREATE TABLE IF NOT EXISTS weekly_reports (
      week_key TEXT PRIMARY KEY NOT NULL,
      note_win TEXT NOT NULL DEFAULT '',
      note_focus TEXT NOT NULL DEFAULT '',
      updated_at TEXT NOT NULL,
      pending_sync INTEGER NOT NULL DEFAULT 0
    );
  `);
}

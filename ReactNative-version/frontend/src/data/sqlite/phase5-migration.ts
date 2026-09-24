import type { SQLiteDatabase } from 'expo-sqlite';

/** Phase 5: persist work_imbalance on daily reports for warning window. Safe to run multiple times. */
export async function migratePhase5Schema(db: SQLiteDatabase): Promise<void> {
  const columns = await db.getAllAsync<{ name: string }>('PRAGMA table_info(daily_reports)');
  const hasWorkImbalance = columns.some((c) => c.name === 'work_imbalance');
  if (!hasWorkImbalance) {
    await db.execAsync(
      'ALTER TABLE daily_reports ADD COLUMN work_imbalance INTEGER NOT NULL DEFAULT 0',
    );
  }
}

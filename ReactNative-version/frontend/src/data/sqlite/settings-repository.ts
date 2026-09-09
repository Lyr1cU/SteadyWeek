import type { SQLiteDatabase } from 'expo-sqlite';
import type { SettingsRepository } from '../ports';

const ONBOARDING_KEY = 'onboarding_complete';

export function createSqliteSettingsRepository(db: SQLiteDatabase): SettingsRepository {
  return {
    async isOnboardingComplete() {
      const row = await db.getFirstAsync<{ value: string }>(
        'SELECT value FROM app_settings WHERE key = ?',
        ONBOARDING_KEY,
      );
      return row?.value === '1';
    },

    async setOnboardingComplete(done: boolean) {
      const now = new Date().toISOString();
      await db.runAsync(
        `INSERT INTO app_settings (key, value, updated_at, pending_sync)
         VALUES (?, ?, ?, 1)
         ON CONFLICT(key) DO UPDATE SET value = excluded.value, updated_at = excluded.updated_at, pending_sync = 1`,
        ONBOARDING_KEY,
        done ? '1' : '0',
        now,
      );
    },
  };
}

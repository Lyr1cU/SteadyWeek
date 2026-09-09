import type { AppRepositories } from '../ports';
import { createSyncEngine } from '../sync/sync-engine';
import { getDatabase } from './database';
import { createSqliteGoalsRepository } from './goals-repository';
import { createSqliteReportsRepository } from './reports-repository';
import { createSqliteRoutineRepository } from './routine-repository';
import { createSqliteSettingsRepository } from './settings-repository';
import { createSqliteStatsRepository } from './stats-repository';
import { withAutoSync, withAutoSyncSettings } from './with-auto-sync';

export async function createSqliteRepositories(): Promise<AppRepositories> {
  const db = await getDatabase();
  const syncEngine = createSyncEngine(db);
  return {
    routine: withAutoSync(createSqliteRoutineRepository(db)),
    goals: createSqliteGoalsRepository(),
    reports: createSqliteReportsRepository(),
    stats: createSqliteStatsRepository(db),
    settings: withAutoSyncSettings(createSqliteSettingsRepository(db)),
    sync: {
      runSync: () => syncEngine.runSync(),
    },
  };
}

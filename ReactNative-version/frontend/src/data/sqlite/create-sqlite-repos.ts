import type { AppRepositories } from '../ports';
import { createDayClosureService } from '../day-closure-service';
import { createSyncEngine } from '../sync/sync-engine';
import { getDatabase } from './database';
import { createSqliteGoalsRepository } from './goals-repository';
import { createSqliteReportsRepository } from './reports-repository';
import { createSqliteRoutineRepository } from './routine-repository';
import { createSqliteSettingsRepository } from './settings-repository';
import { createSqliteStatsRepository } from './stats-repository';
import {
  withAutoSync,
  withAutoSyncDayClosure,
  withAutoSyncGoals,
  withAutoSyncReports,
  withAutoSyncSettings,
} from './with-auto-sync';

export async function createSqliteRepositories(): Promise<AppRepositories> {
  const db = await getDatabase();
  const syncEngine = createSyncEngine(db);
  const goals = createSqliteGoalsRepository(db);
  const reports = createSqliteReportsRepository(db);
  const dayClosure = createDayClosureService(db);
  return {
    routine: withAutoSync(createSqliteRoutineRepository(db)),
    goals: withAutoSyncGoals(goals),
    reports: withAutoSyncReports(reports),
    stats: createSqliteStatsRepository(db),
    settings: withAutoSyncSettings(createSqliteSettingsRepository(db)),
    dayClosure: withAutoSyncDayClosure(dayClosure),
    sync: {
      runSync: () => syncEngine.runSync(),
    },
  };
}

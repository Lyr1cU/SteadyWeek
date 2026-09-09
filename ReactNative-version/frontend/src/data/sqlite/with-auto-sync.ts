import type { RoutineRepository, SettingsRepository } from '../ports';
import { scheduleSync } from '../sync/schedule-sync';

function afterLocalWrite<T>(work: () => Promise<T>): Promise<T> {
  return work().then((result) => {
    scheduleSync();
    return result;
  });
}

export function withAutoSync(routine: RoutineRepository): RoutineRepository {
  return {
    listTemplates: () => routine.listTemplates(),
    loadTodayRows: (date) => routine.loadTodayRows(date),
    createItem: (input) => afterLocalWrite(() => routine.createItem(input)),
    updateItem: (id, input) => afterLocalWrite(() => routine.updateItem(id, input)),
    deleteItem: (id) => afterLocalWrite(() => routine.deleteItem(id)),
    setDayStatus: (date, routineItemId, status) =>
      afterLocalWrite(() => routine.setDayStatus(date, routineItemId, status)),
  };
}

export function withAutoSyncSettings(settings: SettingsRepository): SettingsRepository {
  return {
    isOnboardingComplete: () => settings.isOnboardingComplete(),
    setOnboardingComplete: (done) => afterLocalWrite(() => settings.setOnboardingComplete(done)),
  };
}

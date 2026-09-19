import type { GoalsRepository, ReportsRepository, RoutineRepository, SettingsRepository } from '../ports';
import type { DayClosureService } from '../day-closure-service';
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

export function withAutoSyncGoals(goals: GoalsRepository): GoalsRepository {
  return {
    listForWeek: (weekKey) => goals.listForWeek(weekKey),
    add: (input) => afterLocalWrite(() => goals.add(input)),
    update: (id, input) => afterLocalWrite(() => goals.update(id, input)),
    delete: (id) => afterLocalWrite(() => goals.delete(id)),
    bumpProgress: (id, delta) => afterLocalWrite(() => goals.bumpProgress(id, delta)),
  };
}

export function withAutoSyncReports(reports: ReportsRepository): ReportsRepository {
  return {
    getDaily: (dayKey) => reports.getDaily(dayKey),
    listDailyInWeek: (weekKey, dayKeys) => reports.listDailyInWeek(weekKey, dayKeys),
    getWeekly: (weekKey) => reports.getWeekly(weekKey),
    saveWeeklyNotes: (weekKey, noteWin, noteFocus) =>
      afterLocalWrite(() => reports.saveWeeklyNotes(weekKey, noteWin, noteFocus)),
  };
}

export function withAutoSyncDayClosure(closure: DayClosureService): DayClosureService {
  return {
    submit: (input) => afterLocalWrite(() => closure.submit(input)),
  };
}

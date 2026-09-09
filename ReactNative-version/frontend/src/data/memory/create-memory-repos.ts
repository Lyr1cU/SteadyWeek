import type {
  DailyReport,
  RoutineItem,
  TodayRoutineRow,
  UserStats,
  WeeklyGoal,
} from '../../domain/models';
import { dateKey } from '../../logic/calendar';
import { routineRunsOnDate } from '../../logic/weekdays';
import { DEFAULT_ROUTINE_SEED } from '../seed/default-routine';
import type { AppRepositories, RoutineItemInput } from '../ports';

/** In-memory adapter for tests. Production factory uses SQLite. */
export function createMemoryRepositories(): AppRepositories {
  const templates = DEFAULT_ROUTINE_SEED.map((item, index) => ({
    ...item,
    id: `mem_${index}`,
  }));
  const dayStatus = new Map<string, TodayRoutineRow['status']>();
  const goals: WeeklyGoal[] = [];
  const reports = new Map<string, DailyReport>();
  let onboardingComplete = false;
  let stats: UserStats = {
    totalXp: 0,
    currentStreak: 0,
    bestStreak: 0,
    lastGreenDayKey: null,
  };

  const statusKey = (day: string, itemId: string) => `${day}:${itemId}`;

  return {
    routine: {
      async listTemplates() {
        return [...templates].sort((a, b) => a.order - b.order);
      },
      async createItem(input: RoutineItemInput) {
        const item: RoutineItem = {
          id: `r_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`,
          title: input.title.trim(),
          sphere: input.sphere,
          weekdays: input.weekdays,
          order: templates.length,
          effort: input.effort,
          isOptional: input.isOptional,
          scheduledMinuteOfDay: input.scheduledMinuteOfDay,
        };
        templates.push(item);
        return item;
      },
      async updateItem(id, input) {
        const index = templates.findIndex((t) => t.id === id);
        if (index < 0) {
          throw new Error(`Routine item not found: ${id}`);
        }
        const updated = {
          ...templates[index],
          title: input.title.trim(),
          sphere: input.sphere,
          weekdays: input.weekdays,
          effort: input.effort,
          isOptional: input.isOptional,
          scheduledMinuteOfDay: input.scheduledMinuteOfDay,
        };
        templates[index] = updated;
        return updated;
      },
      async deleteItem(id) {
        const index = templates.findIndex((t) => t.id === id);
        if (index < 0) {
          throw new Error(`Routine item not found: ${id}`);
        }
        templates.splice(index, 1);
      },
      async loadTodayRows(date) {
        const key = dateKey(date);
        const items = templates.filter((t) => routineRunsOnDate(t.weekdays, date));
        return items.map((item) => ({
          item,
          status: dayStatus.get(statusKey(key, item.id)) ?? 'pending',
        }));
      },
      async setDayStatus(date, routineItemId, status) {
        dayStatus.set(statusKey(dateKey(date), routineItemId), status);
      },
    },
    goals: {
      async listForWeek(weekKey) {
        return goals.filter((g) => g.weekKey === weekKey);
      },
    },
    reports: {
      async getDaily(dayKeyValue) {
        return reports.get(dayKeyValue) ?? null;
      },
    },
    stats: {
      async get() {
        return { ...stats };
      },
    },
    settings: {
      async isOnboardingComplete() {
        return onboardingComplete;
      },
      async setOnboardingComplete(done) {
        onboardingComplete = done;
      },
    },
    sync: {
      async runSync() {},
    },
  };
}

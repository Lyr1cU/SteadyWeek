import type {
  DailyReport,
  RoutineItem,
  TodayRoutineRow,
  UserStats,
  WeeklyGoal,
  WeeklyGoalInput,
  WeeklyReport,
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
  const weeklyNotes = new Map<string, WeeklyReport>();
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
      async add(input: WeeklyGoalInput) {
        const goal: WeeklyGoal = {
          id: `g_${goals.length}`,
          weekKey: input.weekKey,
          sphere: input.sphere,
          title: input.title.trim(),
          targetCount: Math.max(1, input.targetCount ?? 1),
          progressCount: 0,
          status: 'active',
        };
        goals.push(goal);
        return goal;
      },
      async update(id, input) {
        const index = goals.findIndex((g) => g.id === id);
        if (index < 0) throw new Error('goal not found');
        const next = {
          ...goals[index],
          weekKey: input.weekKey,
          sphere: input.sphere,
          title: input.title.trim(),
          targetCount: Math.max(1, input.targetCount ?? goals[index].targetCount),
        };
        goals[index] = next;
        return next;
      },
      async delete(id) {
        const index = goals.findIndex((g) => g.id === id);
        if (index >= 0) goals.splice(index, 1);
      },
      async bumpProgress(id, delta) {
        const g = goals.find((x) => x.id === id);
        if (!g) return null;
        const t = g.targetCount <= 0 ? 1 : g.targetCount;
        g.progressCount = Math.min(Math.max(0, g.progressCount + delta), t);
        g.status = g.progressCount >= t ? 'completed' : 'active';
        return { ...g };
      },
    },
    reports: {
      async getDaily(dayKeyValue) {
        return reports.get(dayKeyValue) ?? null;
      },
      async listDailyInWeek(_weekKey, dayKeys) {
        return dayKeys
          .map((k) => reports.get(k))
          .filter((r): r is DailyReport => r != null);
      },
      async getWeekly(weekKey) {
        return weeklyNotes.get(weekKey) ?? null;
      },
      async saveWeeklyNotes(weekKey, noteWin, noteFocus) {
        const row = { weekKey, noteWin, noteFocus, updatedAt: new Date().toISOString() };
        weeklyNotes.set(weekKey, row);
        return row;
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
    dayClosure: {
      async submit() {
        throw new Error('Use SQLite dayClosure in app');
      },
    },
  };
}

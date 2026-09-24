import type {
  DailyReport,
  RoutineItem,
  RoutineItemInput,
  TodayRoutineRow,
  UserStats,
  WeeklyGoal,
  WeeklyGoalInput,
  WeeklyReport,
} from '../domain/models';
import type { DayClosureService } from './day-closure-service';

export type { RoutineItemInput };

export type RoutineRepository = {
  listTemplates(): Promise<RoutineItem[]>;
  createItem(input: RoutineItemInput): Promise<RoutineItem>;
  updateItem(id: string, input: RoutineItemInput): Promise<RoutineItem>;
  deleteItem(id: string): Promise<void>;
  loadTodayRows(date: Date): Promise<TodayRoutineRow[]>;
  setDayStatus(
    date: Date,
    routineItemId: string,
    status: TodayRoutineRow['status'],
  ): Promise<void>;
};

export type GoalsRepository = {
  listForWeek(weekKey: string): Promise<WeeklyGoal[]>;
  add(input: WeeklyGoalInput): Promise<WeeklyGoal>;
  update(id: string, input: WeeklyGoalInput): Promise<WeeklyGoal>;
  delete(id: string): Promise<void>;
  bumpProgress(id: string, delta: number): Promise<WeeklyGoal | null>;
};

export type ReportsRepository = {
  getDaily(dayKey: string): Promise<DailyReport | null>;
  listDailyInWeek(weekKey: string, dayKeys: string[]): Promise<DailyReport[]>;
  listDailyInDayKeyRange(startKey: string, endKey: string): Promise<DailyReport[]>;
  getWeekly(weekKey: string): Promise<WeeklyReport | null>;
  saveWeeklyNotes(weekKey: string, noteWin: string, noteFocus: string): Promise<WeeklyReport>;
};

export type StatsRepository = {
  get(): Promise<UserStats>;
};

export type SettingsRepository = {
  isOnboardingComplete(): Promise<boolean>;
  setOnboardingComplete(done: boolean): Promise<void>;
};

export type SyncRepository = {
  runSync(): Promise<void>;
};

export type AppRepositories = {
  routine: RoutineRepository;
  goals: GoalsRepository;
  reports: ReportsRepository;
  stats: StatsRepository;
  settings: SettingsRepository;
  sync: SyncRepository;
  dayClosure: DayClosureService;
};

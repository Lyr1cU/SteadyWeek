import type {
  DailyReport,
  RoutineItem,
  RoutineItemInput,
  TodayRoutineRow,
  UserStats,
  WeeklyGoal,
} from '../domain/models';

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
};

export type ReportsRepository = {
  getDaily(dayKey: string): Promise<DailyReport | null>;
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
};

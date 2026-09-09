export type SyncRoutineRow = {
  id: string;
  title: string;
  sphere: string;
  weekdays: number;
  sort_order: number;
  effort: string;
  is_optional: number;
  scheduled_minute_of_day: number | null;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
};

export type PushPayload = {
  routineItems: Array<{
    id: string;
    title: string;
    sphere: string;
    weekdays: number;
    sortOrder: number;
    effort: string;
    isOptional: boolean;
    scheduledMinuteOfDay: number | null;
    createdAt: string;
    updatedAt: string;
    deletedAt: string | null;
  }>;
  dayItemStatus: Array<{
    dayKey: string;
    routineItemId: string;
    status: string;
    updatedAt: string;
  }>;
  appSettings: Array<{
    key: string;
    value: string;
    updatedAt: string;
  }>;
  userStats: {
    totalXp: number;
    currentStreak: number;
    bestStreak: number;
    lastGreenDayKey: string | null;
    updatedAt: string;
  } | null;
};

export type PullResponse = {
  routineItems: Array<{
    id: string;
    title: string;
    sphere: string;
    weekdays: number;
    sortOrder: number;
    effort: string;
    isOptional: boolean;
    scheduledMinuteOfDay: number | null;
    createdAt: string;
    updatedAt: string;
    deletedAt: string | null;
  }>;
  dayItemStatus: Array<{
    dayKey: string;
    routineItemId: string;
    status: string;
    updatedAt: string;
  }>;
  appSettings: Array<{
    key: string;
    value: string;
    updatedAt: string;
  }>;
  userStats: {
    totalXp: number;
    currentStreak: number;
    bestStreak: number;
    lastGreenDayKey: string | null;
    updatedAt: string;
  } | null;
  serverTime: string;
};

export function pullHasCloudData(pull: PullResponse): boolean {
  return pull.routineItems.length > 0 || pull.dayItemStatus.length > 0;
}

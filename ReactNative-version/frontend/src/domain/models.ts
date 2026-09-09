import type { DayTier } from './day-tier';
import type { LifeSphereId } from './life-sphere';

export type Effort = 'light' | 'medium' | 'heavy';

export type DayItemStatus = 'pending' | 'done' | 'skipped';

export type GoalStatus = 'active' | 'completed' | 'failed' | 'dropped';

/** Template row — MASTER_PLAN §3.2 */
export type RoutineItem = {
  id: string;
  title: string;
  sphere: LifeSphereId;
  /** Bitmask Mon=1 … Sun=64 (same idea as Flutter `weekdays` int). */
  weekdays: number;
  order: number;
  effort: Effort;
  isOptional: boolean;
  scheduledMinuteOfDay: number | null;
};

export type TodayRoutineRow = {
  item: RoutineItem;
  status: DayItemStatus;
};

/** MASTER_PLAN §3.4 */
export type WeeklyGoal = {
  id: string;
  weekKey: string;
  sphere: LifeSphereId;
  title: string;
  targetCount: number;
  progressCount: number;
  status: GoalStatus;
};

export type DailyReport = {
  dayKey: string;
  mood: number | null;
  noteHighlight: string;
  noteReflection: string;
  dayTier: DayTier;
  xpAwarded: number;
  closedAt: string;
};

export type UserStats = {
  totalXp: number;
  currentStreak: number;
  bestStreak: number;
  lastGreenDayKey: string | null;
};

export type { ShopItemCategory } from './shop';

/** Form payload for create/update — no id or sort order yet. */
export type RoutineItemInput = {
  title: string;
  sphere: LifeSphereId;
  weekdays: number;
  effort: Effort;
  isOptional: boolean;
  scheduledMinuteOfDay: number | null;
};

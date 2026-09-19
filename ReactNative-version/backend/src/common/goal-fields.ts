export const GOAL_STATUSES = ['active', 'completed', 'failed', 'dropped'] as const;
export const DAY_TIERS = ['green', 'yellow', 'red'] as const;

export type GoalStatus = (typeof GOAL_STATUSES)[number];
export type DayTier = (typeof DAY_TIERS)[number];

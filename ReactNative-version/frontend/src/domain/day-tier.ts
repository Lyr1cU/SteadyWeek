/** Stored as these strings (Flutter used ints 0/1/2). */
export const DAY_TIERS = ['green', 'yellow', 'red'] as const;

export type DayTier = (typeof DAY_TIERS)[number];

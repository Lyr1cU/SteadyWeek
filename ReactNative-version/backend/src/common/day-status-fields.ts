export const DAY_ITEM_STATUSES = ['pending', 'done', 'skipped'] as const;

export type DayItemStatusValue = (typeof DAY_ITEM_STATUSES)[number];

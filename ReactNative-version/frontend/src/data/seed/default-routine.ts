import type { RoutineItem } from '../../domain/models';

/** Shared seed for SQLite (first launch) and the in-memory adapter. IDs are assigned at insert time — never reuse r1/r2/r3 across users. */
export const DEFAULT_ROUTINE_SEED: Omit<RoutineItem, 'id'>[] = [
  {
    title: 'Deep work block',
    sphere: 'work',
    weekdays: 31,
    order: 0,
    effort: 'heavy',
    isOptional: false,
    scheduledMinuteOfDay: 9 * 60,
  },
  {
    title: 'Walk or stretch',
    sphere: 'body',
    weekdays: 127,
    order: 1,
    effort: 'light',
    isOptional: false,
    scheduledMinuteOfDay: 18 * 60,
  },
  {
    title: 'Message someone',
    sphere: 'social',
    weekdays: 127,
    order: 2,
    effort: 'light',
    isOptional: true,
    scheduledMinuteOfDay: null,
  },
];

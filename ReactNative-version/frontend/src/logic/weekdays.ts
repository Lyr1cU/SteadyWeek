/** Mon=bit 0 … Sun=bit 6 — same mask as Flutter `weekdays` int. */

export const WEEKDAY_LABELS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] as const;

export function weekdayMaskFromIndex(index: number): number {
  return 1 << index;
}

export function mondayBasedWeekdayIndex(date: Date): number {
  const dow = date.getDay();
  return dow === 0 ? 6 : dow - 1;
}

export function weekdayBit(date: Date): number {
  return 1 << mondayBasedWeekdayIndex(date);
}

export function weekdayLabel(date: Date): string {
  return WEEKDAY_LABELS[mondayBasedWeekdayIndex(date)];
}

export function routineRunsOnDate(weekdaysMask: number, date: Date): boolean {
  return (weekdaysMask & weekdayBit(date)) !== 0;
}

export function toggleWeekdayMask(mask: number, index: number): number {
  return mask ^ weekdayMaskFromIndex(index);
}

export function formatWeekdaysMask(mask: number): string {
  if (mask === 0) {
    return 'none';
  }
  if (mask === 127) {
    return 'every day';
  }
  return WEEKDAY_LABELS.filter((_, index) => (mask & weekdayMaskFromIndex(index)) !== 0).join(', ');
}

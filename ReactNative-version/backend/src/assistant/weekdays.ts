/** Mon=bit 0 … Sun=bit 6 — matches client `logic/weekdays.ts`. */

export function parseDayKey(dayKey: string): Date {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(dayKey);
  if (!match) {
    throw new Error(`Invalid dayKey: ${dayKey}`);
  }
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const date = new Date(year, month - 1, day, 12, 0, 0, 0);
  if (date.getFullYear() !== year || date.getMonth() !== month - 1 || date.getDate() !== day) {
    throw new Error(`Invalid dayKey: ${dayKey}`);
  }
  return date;
}

function mondayBasedWeekdayIndex(date: Date): number {
  const dow = date.getDay();
  return dow === 0 ? 6 : dow - 1;
}

export function weekdayBit(date: Date): number {
  return 1 << mondayBasedWeekdayIndex(date);
}

export function routineRunsOnDate(weekdaysMask: number, date: Date): boolean {
  return (weekdaysMask & weekdayBit(date)) !== 0;
}

/** Parse `yyyy-MM-dd` as local midnight (same as backend dayKey). */
export function localDayFromKey(dayKey: string): Date {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(dayKey);
  if (!match) {
    throw new Error('Invalid dayKey');
  }
  const y = Number(match[1]);
  const m = Number(match[2]);
  const d = Number(match[3]);
  return new Date(y, m - 1, d);
}

/** Local calendar `yyyy-MM-dd` — same as Flutter `dateKey`. */
export function dateKey(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

export function startOfLocalDay(date: Date): Date {
  return new Date(date.getFullYear(), date.getMonth(), date.getDate());
}

export function addLocalDays(date: Date, delta: number): Date {
  const next = startOfLocalDay(date);
  next.setDate(next.getDate() + delta);
  return next;
}

export function mondayOfWeekContaining(date: Date): Date {
  const start = startOfLocalDay(date);
  const dow = start.getDay(); // 0 Sun … 6 Sat
  const offset = dow === 0 ? -6 : 1 - dow;
  start.setDate(start.getDate() + offset);
  return start;
}

/** Monday `yyyy-MM-dd` — Flutter `weekKeyFromDate`. */
export function weekKeyFromDate(date: Date): string {
  return dateKey(mondayOfWeekContaining(date));
}

/** Seven day keys Mon–Sun for the week starting at `weekKey`. */
export function dayKeysForWeek(weekKey: string): string[] {
  const monday = localDayFromKey(weekKey);
  return Array.from({ length: 7 }, (_, i) => dateKey(addLocalDays(monday, i)));
}

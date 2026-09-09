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

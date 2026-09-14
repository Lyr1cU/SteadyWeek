/** Local calendar date key YYYY-MM-DD (server uses same parsing as client day keys). */

export function formatDayKey(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

export function addDays(date: Date, days: number): Date {
  const next = new Date(date);
  next.setDate(next.getDate() + days);
  return next;
}

/** Monday 00:00 local for the week containing [date]. */
export function startOfWeekMonday(date: Date): Date {
  const d = new Date(date.getFullYear(), date.getMonth(), date.getDate(), 12, 0, 0, 0);
  const dow = d.getDay();
  const fromMonday = dow === 0 ? 6 : dow - 1;
  d.setDate(d.getDate() - fromMonday);
  return d;
}

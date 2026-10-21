/** Calendar day key in optional IANA timezone (defaults to host local). */
export function localDayKey(timezone: string | null, date = new Date()): string {
  if (timezone) {
    try {
      return new Intl.DateTimeFormat('en-CA', {
        timeZone: timezone,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      }).format(date);
    } catch {
      throw new Error(`Invalid STEADYWEEK_TIMEZONE: ${timezone}`);
    }
  }
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

export function dayKeyMeta(timezone: string | null, dayKey: string) {
  return {
    dayKey,
    timezoneUsed: timezone ?? 'host-local',
    resolvedAt: new Date().toISOString(),
  };
}

/** Monday yyyy-MM-dd for the week containing [dayKey] (local calendar math on parsed date). */
export function weekKeyFromDayKey(dayKey: string): string {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(dayKey);
  if (!match) {
    throw new Error('Invalid dayKey');
  }
  const y = Number(match[1]);
  const m = Number(match[2]);
  const d = Number(match[3]);
  const date = new Date(y, m - 1, d, 12, 0, 0, 0);
  const dow = date.getDay();
  const offset = dow === 0 ? -6 : 1 - dow;
  date.setDate(date.getDate() + offset);
  const wy = date.getFullYear();
  const wm = String(date.getMonth() + 1).padStart(2, '0');
  const wd = String(date.getDate()).padStart(2, '0');
  return `${wy}-${wm}-${wd}`;
}

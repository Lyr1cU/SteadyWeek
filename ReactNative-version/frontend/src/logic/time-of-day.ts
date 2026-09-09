export function formatMinuteOfDay(minute: number | null): string {
  if (minute == null) {
    return 'any time';
  }
  const hours = Math.floor(minute / 60);
  const mins = minute % 60;
  return `${String(hours).padStart(2, '0')}:${String(mins).padStart(2, '0')}`;
}

export function parseTimeInput(value: string): number | null {
  const trimmed = value.trim();
  if (!trimmed) {
    return null;
  }
  const match = /^(\d{1,2}):(\d{2})$/.exec(trimmed);
  if (!match) {
    return null;
  }
  const hours = Number(match[1]);
  const mins = Number(match[2]);
  if (hours < 0 || hours > 23 || mins < 0 || mins > 59) {
    return null;
  }
  return hours * 60 + mins;
}

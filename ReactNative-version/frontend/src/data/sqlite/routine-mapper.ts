import type { DayItemStatus, Effort, RoutineItem } from '../../domain/models';
import { isLifeSphereId } from '../../domain/life-sphere';

export type RoutineRow = {
  id: string;
  title: string;
  sphere: string;
  weekdays: number;
  sort_order: number;
  effort: string;
  is_optional: number;
  scheduled_minute_of_day: number | null;
};

const EFFORTS: readonly Effort[] = ['light', 'medium', 'heavy'];
const STATUSES: readonly DayItemStatus[] = ['pending', 'done', 'skipped'];

function isEffort(value: string): value is Effort {
  return (EFFORTS as readonly string[]).includes(value);
}

export function mapDayStatus(value: string | null | undefined): DayItemStatus {
  if (value && (STATUSES as readonly string[]).includes(value)) {
    return value as DayItemStatus;
  }
  return 'pending';
}

export function tryMapRoutineRow(row: RoutineRow): RoutineItem | null {
  if (!isLifeSphereId(row.sphere) || !isEffort(row.effort)) {
    return null;
  }

  return {
    id: row.id,
    title: row.title,
    sphere: row.sphere,
    weekdays: row.weekdays,
    order: row.sort_order,
    effort: row.effort,
    isOptional: row.is_optional === 1,
    scheduledMinuteOfDay: row.scheduled_minute_of_day,
  };
}

export function mapRoutineRow(row: RoutineRow): RoutineItem {
  const item = tryMapRoutineRow(row);
  if (!item) {
    throw new Error(`Unknown sphere or effort: ${row.sphere}/${row.effort}`);
  }
  return item;
}

export function newRoutineId(): string {
  return `r_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

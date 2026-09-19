import type { GoalStatus, WeeklyGoal } from '../../domain/models';
import { isLifeSphereId } from '../../domain/life-sphere';

export type GoalRow = {
  id: string;
  week_key: string;
  sphere: string;
  title: string;
  target_count: number;
  progress_count: number;
  status: string;
};

const GOAL_STATUSES: readonly GoalStatus[] = ['active', 'completed', 'failed', 'dropped'];

function mapGoalStatus(value: string): GoalStatus {
  if ((GOAL_STATUSES as readonly string[]).includes(value)) {
    return value as GoalStatus;
  }
  return 'active';
}

export function mapGoalRow(row: GoalRow): WeeklyGoal | null {
  if (!isLifeSphereId(row.sphere)) {
    return null;
  }
  return {
    id: row.id,
    weekKey: row.week_key,
    sphere: row.sphere,
    title: row.title,
    targetCount: row.target_count,
    progressCount: row.progress_count,
    status: mapGoalStatus(row.status),
  };
}

export function newGoalId(): string {
  return `g_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

import type { SQLiteDatabase } from 'expo-sqlite';
import type { WeeklyGoal, WeeklyGoalInput } from '../../domain/models';
import type { GoalsRepository } from '../ports';
import { mapGoalRow, newGoalId, type GoalRow } from './goal-mapper';

export function createSqliteGoalsRepository(db: SQLiteDatabase): GoalsRepository {
  return {
    async listForWeek(weekKey: string): Promise<WeeklyGoal[]> {
      const rows = await db.getAllAsync<GoalRow>(
        `SELECT id, week_key, sphere, title, target_count, progress_count, status
         FROM weekly_goals
         WHERE week_key = ? AND deleted_at IS NULL
         ORDER BY id ASC`,
        weekKey,
      );
      return rows.map(mapGoalRow).filter((g): g is WeeklyGoal => g != null);
    },

    async add(input: WeeklyGoalInput): Promise<WeeklyGoal> {
      const title = input.title.trim();
      if (!title) {
        throw new Error('Goal title is required');
      }
      const id = newGoalId();
      const targetCount = Math.max(1, input.targetCount ?? 1);
      const updatedAt = new Date().toISOString();
      await db.runAsync(
        `INSERT INTO weekly_goals (
          id, week_key, sphere, title, target_count, progress_count, status,
          updated_at, deleted_at, pending_sync
        ) VALUES (?, ?, ?, ?, ?, 0, 'active', ?, NULL, 1)`,
        id,
        input.weekKey,
        input.sphere,
        title,
        targetCount,
        updatedAt,
      );
      return {
        id,
        weekKey: input.weekKey,
        sphere: input.sphere,
        title,
        targetCount,
        progressCount: 0,
        status: 'active',
      };
    },

    async update(id: string, input: WeeklyGoalInput): Promise<WeeklyGoal> {
      const existing = await db.getFirstAsync<GoalRow & { deleted_at: string | null }>(
        `SELECT id, week_key, sphere, title, target_count, progress_count, status, deleted_at
         FROM weekly_goals WHERE id = ?`,
        id,
      );
      if (!existing || existing.deleted_at) {
        throw new Error(`Weekly goal not found: ${id}`);
      }
      const targetCount = Math.max(1, input.targetCount ?? existing.target_count);
      const progressCount = Math.min(existing.progress_count, targetCount);
      const status =
        progressCount >= targetCount
          ? 'completed'
          : existing.status === 'completed'
            ? 'active'
            : existing.status;
      const updatedAt = new Date().toISOString();
      await db.runAsync(
        `UPDATE weekly_goals SET
          week_key = ?, sphere = ?, title = ?, target_count = ?, progress_count = ?,
          status = ?, updated_at = ?, pending_sync = 1
         WHERE id = ?`,
        input.weekKey,
        input.sphere,
        input.title.trim(),
        targetCount,
        progressCount,
        status,
        updatedAt,
        id,
      );
      const mapped = mapGoalRow({
        id,
        week_key: input.weekKey,
        sphere: input.sphere,
        title: input.title.trim(),
        target_count: targetCount,
        progress_count: progressCount,
        status,
      });
      if (!mapped) {
        throw new Error('Invalid goal sphere');
      }
      return mapped;
    },

    async delete(id: string): Promise<void> {
      const updatedAt = new Date().toISOString();
      await db.runAsync(
        `UPDATE weekly_goals SET deleted_at = ?, updated_at = ?, pending_sync = 1 WHERE id = ?`,
        updatedAt,
        updatedAt,
        id,
      );
    },

    async bumpProgress(id: string, delta: number): Promise<WeeklyGoal | null> {
      const row = await db.getFirstAsync<GoalRow>(
        `SELECT id, week_key, sphere, title, target_count, progress_count, status
         FROM weekly_goals WHERE id = ? AND deleted_at IS NULL`,
        id,
      );
      if (!row) {
        return null;
      }
      const target = row.target_count <= 0 ? 1 : row.target_count;
      const next = Math.min(Math.max(0, row.progress_count + delta), target);
      const status = next >= target ? 'completed' : 'active';
      const updatedAt = new Date().toISOString();
      await db.runAsync(
        `UPDATE weekly_goals SET progress_count = ?, status = ?, updated_at = ?, pending_sync = 1 WHERE id = ?`,
        next,
        status,
        updatedAt,
        id,
      );
      return mapGoalRow({
        ...row,
        progress_count: next,
        status,
      });
    },
  };
}

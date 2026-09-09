import type { SQLiteDatabase } from 'expo-sqlite';
import type { RoutineItem, RoutineItemInput, TodayRoutineRow } from '../../domain/models';
import { dateKey } from '../../logic/calendar';
import { routineRunsOnDate } from '../../logic/weekdays';
import type { RoutineRepository } from '../ports';
import { mapDayStatus, mapRoutineRow, newRoutineId, type RoutineRow } from './routine-mapper';

const ROUTINE_SELECT = `SELECT id, title, sphere, weekdays, sort_order, effort,
                  is_optional, scheduled_minute_of_day
           FROM routine_items`;

export function createSqliteRoutineRepository(db: SQLiteDatabase): RoutineRepository {
  return {
    async listTemplates() {
      const rows = await db.getAllAsync<RoutineRow>(
        `${ROUTINE_SELECT}
           WHERE deleted_at IS NULL
           ORDER BY sort_order ASC, title ASC`,
      );
      return rows.map(mapRoutineRow);
    },

    async createItem(input: RoutineItemInput) {
      const now = new Date().toISOString();
      const maxOrder = await db.getFirstAsync<{ maxOrder: number | null }>(
        'SELECT MAX(sort_order) AS maxOrder FROM routine_items WHERE deleted_at IS NULL',
      );
      const id = newRoutineId();
      const sortOrder = (maxOrder?.maxOrder ?? -1) + 1;

      await db.runAsync(
        `INSERT INTO routine_items (
            id, title, sphere, weekdays, sort_order, effort,
            is_optional, scheduled_minute_of_day, created_at, updated_at, pending_sync
          ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)`,
        id,
        input.title.trim(),
        input.sphere,
        input.weekdays,
        sortOrder,
        input.effort,
        input.isOptional ? 1 : 0,
        input.scheduledMinuteOfDay,
        now,
        now,
      );

      return {
        id,
        title: input.title.trim(),
        sphere: input.sphere,
        weekdays: input.weekdays,
        order: sortOrder,
        effort: input.effort,
        isOptional: input.isOptional,
        scheduledMinuteOfDay: input.scheduledMinuteOfDay,
      } satisfies RoutineItem;
    },

    async updateItem(id, input) {
      const now = new Date().toISOString();
      const result = await db.runAsync(
        `UPDATE routine_items SET
            title = ?, sphere = ?, weekdays = ?, effort = ?,
            is_optional = ?, scheduled_minute_of_day = ?, updated_at = ?, pending_sync = 1
           WHERE id = ? AND deleted_at IS NULL`,
        input.title.trim(),
        input.sphere,
        input.weekdays,
        input.effort,
        input.isOptional ? 1 : 0,
        input.scheduledMinuteOfDay,
        now,
        id,
      );
      if (result.changes === 0) {
        throw new Error(`Routine item not found: ${id}`);
      }

      const row = await db.getFirstAsync<RoutineRow>(`${ROUTINE_SELECT} WHERE id = ?`, id);
      if (!row) {
        throw new Error(`Routine item not found: ${id}`);
      }
      return mapRoutineRow(row);
    },

    async deleteItem(id) {
      const now = new Date().toISOString();
      const result = await db.runAsync(
        'UPDATE routine_items SET deleted_at = ?, updated_at = ?, pending_sync = 1 WHERE id = ? AND deleted_at IS NULL',
        now,
        now,
        id,
      );
      if (result.changes === 0) {
        throw new Error(`Routine item not found: ${id}`);
      }
    },

    async loadTodayRows(date) {
      const key = dateKey(date);
      const items = await this.listTemplates();
      const scheduled = items.filter((item) => routineRunsOnDate(item.weekdays, date));
      if (scheduled.length === 0) {
        return [];
      }

      const statusRows = await db.getAllAsync<{ routine_item_id: string; status: string }>(
        'SELECT routine_item_id, status FROM day_item_status WHERE day_key = ?',
        key,
      );
      const statusById = new Map(
        statusRows.map((row) => [row.routine_item_id, mapDayStatus(row.status)]),
      );

      const rows: TodayRoutineRow[] = scheduled.map((item) => ({
        item,
        status: statusById.get(item.id) ?? 'pending',
      }));

      return rows;
    },

    async setDayStatus(date, routineItemId, status) {
      const now = new Date().toISOString();
      await db.runAsync(
        `INSERT INTO day_item_status (day_key, routine_item_id, status, updated_at, pending_sync)
           VALUES (?, ?, ?, ?, 1)
           ON CONFLICT(day_key, routine_item_id)
           DO UPDATE SET status = excluded.status, updated_at = excluded.updated_at, pending_sync = 1`,
        dateKey(date),
        routineItemId,
        status,
        now,
      );
    },
  };
}

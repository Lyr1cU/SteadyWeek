import type { SQLiteDatabase } from 'expo-sqlite';
import type { PullResponse } from './sync-types';

export async function applyPull(db: SQLiteDatabase, pull: PullResponse): Promise<void> {
  const weeklyGoals = pull.weeklyGoals ?? [];
  const dailyReports = pull.dailyReports ?? [];
  const weeklyReports = pull.weeklyReports ?? [];

  await db.withTransactionAsync(async () => {
    for (const item of pull.routineItems) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM routine_items WHERE id = ?',
        item.id,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > item.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO routine_items (
          id, title, sphere, weekdays, sort_order, effort, is_optional,
          scheduled_minute_of_day, created_at, updated_at, deleted_at, pending_sync
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)
        ON CONFLICT(id) DO UPDATE SET
          title = excluded.title,
          sphere = excluded.sphere,
          weekdays = excluded.weekdays,
          sort_order = excluded.sort_order,
          effort = excluded.effort,
          is_optional = excluded.is_optional,
          scheduled_minute_of_day = excluded.scheduled_minute_of_day,
          updated_at = excluded.updated_at,
          deleted_at = excluded.deleted_at,
          pending_sync = 0`,
        item.id,
        item.title,
        item.sphere,
        item.weekdays,
        item.sortOrder,
        item.effort,
        item.isOptional ? 1 : 0,
        item.scheduledMinuteOfDay,
        item.createdAt,
        item.updatedAt,
        item.deletedAt,
      );
    }

    for (const row of pull.dayItemStatus) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        `SELECT updated_at, pending_sync FROM day_item_status
         WHERE day_key = ? AND routine_item_id = ?`,
        row.dayKey,
        row.routineItemId,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > row.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO day_item_status (day_key, routine_item_id, status, updated_at, pending_sync)
         VALUES (?, ?, ?, ?, 0)
         ON CONFLICT(day_key, routine_item_id) DO UPDATE SET
           status = excluded.status,
           updated_at = excluded.updated_at,
           pending_sync = 0`,
        row.dayKey,
        row.routineItemId,
        row.status,
        row.updatedAt,
      );
    }

    for (const row of pull.appSettings) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM app_settings WHERE key = ?',
        row.key,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > row.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO app_settings (key, value, updated_at, pending_sync)
         VALUES (?, ?, ?, 0)
         ON CONFLICT(key) DO UPDATE SET
           value = excluded.value,
           updated_at = excluded.updated_at,
           pending_sync = 0`,
        row.key,
        row.value,
        row.updatedAt,
      );
    }

    if (pull.userStats) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM user_stats WHERE id = 1',
      );
      if (local?.pending_sync !== 1 && !(local && local.updated_at > pull.userStats.updatedAt)) {
        await db.runAsync(
          `UPDATE user_stats SET
            total_xp = ?, current_streak = ?, best_streak = ?,
            last_green_day_key = ?, updated_at = ?, pending_sync = 0
           WHERE id = 1`,
          pull.userStats.totalXp,
          pull.userStats.currentStreak,
          pull.userStats.bestStreak,
          pull.userStats.lastGreenDayKey,
          pull.userStats.updatedAt,
        );
      }
    }

    for (const goal of weeklyGoals) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM weekly_goals WHERE id = ?',
        goal.id,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > goal.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO weekly_goals (
          id, week_key, sphere, title, target_count, progress_count, status,
          updated_at, deleted_at, pending_sync
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)
        ON CONFLICT(id) DO UPDATE SET
          week_key = excluded.week_key,
          sphere = excluded.sphere,
          title = excluded.title,
          target_count = excluded.target_count,
          progress_count = excluded.progress_count,
          status = excluded.status,
          updated_at = excluded.updated_at,
          deleted_at = excluded.deleted_at,
          pending_sync = 0`,
        goal.id,
        goal.weekKey,
        goal.sphere,
        goal.title,
        goal.targetCount,
        goal.progressCount,
        goal.status,
        goal.updatedAt,
        goal.deletedAt,
      );
    }

    for (const report of dailyReports) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM daily_reports WHERE day_key = ?',
        report.dayKey,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > report.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO daily_reports (
          day_key, mood, note_highlight, note_reflection, day_tier, xp_awarded,
          closed_at, updated_at, pending_sync
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)
        ON CONFLICT(day_key) DO UPDATE SET
          mood = excluded.mood,
          note_highlight = excluded.note_highlight,
          note_reflection = excluded.note_reflection,
          day_tier = excluded.day_tier,
          xp_awarded = excluded.xp_awarded,
          closed_at = excluded.closed_at,
          updated_at = excluded.updated_at,
          pending_sync = 0`,
        report.dayKey,
        report.mood,
        report.noteHighlight,
        report.noteReflection,
        report.dayTier,
        report.xpAwarded,
        report.closedAt,
        report.updatedAt,
      );
    }

    for (const report of weeklyReports) {
      const local = await db.getFirstAsync<{ updated_at: string; pending_sync: number }>(
        'SELECT updated_at, pending_sync FROM weekly_reports WHERE week_key = ?',
        report.weekKey,
      );
      if (local?.pending_sync === 1) {
        continue;
      }
      if (local && local.updated_at > report.updatedAt) {
        continue;
      }

      await db.runAsync(
        `INSERT INTO weekly_reports (week_key, note_win, note_focus, updated_at, pending_sync)
         VALUES (?, ?, ?, ?, 0)
         ON CONFLICT(week_key) DO UPDATE SET
           note_win = excluded.note_win,
           note_focus = excluded.note_focus,
           updated_at = excluded.updated_at,
           pending_sync = 0`,
        report.weekKey,
        report.noteWin,
        report.noteFocus,
        report.updatedAt,
      );
    }
  });
}

/** Restore from cloud: drop local schedule, then apply the full pull. Keeps onboarding flag. */
export async function replaceScheduleFromPull(db: SQLiteDatabase, pull: PullResponse): Promise<void> {
  await db.execAsync(`
    DELETE FROM day_item_status;
    DELETE FROM routine_items;
    DELETE FROM weekly_goals;
    DELETE FROM daily_reports;
    DELETE FROM weekly_reports;
  `);
  await applyPull(db, pull);
}

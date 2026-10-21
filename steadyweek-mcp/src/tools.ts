import type { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { z } from 'zod';
import type { SteadyWeekApi } from './api.js';
import { dayKeyMeta, localDayKey, weekKeyFromDayKey } from './calendar.js';
import type { SteadyWeekConfig } from './config.js';

const DAY_KEY = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);
const LIFE_SPHERES = ['work', 'body', 'social', 'rest', 'home', 'growth'] as const;
const DAY_STATUSES = ['pending', 'done', 'skipped'] as const;
const GOAL_STATUSES = ['active', 'completed', 'failed', 'dropped'] as const;

const WEEKDAYS_HELP =
  'Weekdays bitmask: Mon=1, Tue=2, Wed=4, Thu=8, Fri=16, Sat=32, Sun=64 (sum days). Example: Mon–Fri = 31.';

function jsonResult(data: unknown) {
  return {
    content: [{ type: 'text' as const, text: JSON.stringify(data, null, 2) }],
  };
}

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export function registerTools(server: McpServer, api: SteadyWeekApi, config: SteadyWeekConfig) {
  const resolveToday = (dayKey?: string) => dayKey ?? localDayKey(config.timezone);

  server.tool(
    'get_today',
    `Today’s schedule + item statuses. Default day uses STEADYWEEK_TIMEZONE or host local. Phone syncs ~45s or after MCP nudge.`,
    {
      dayKey: DAY_KEY.optional().describe('Optional YYYY-MM-DD; overrides default “today”'),
    },
    async ({ dayKey }) => {
      const key = resolveToday(dayKey);
      const schedule = (await api.getDay(key)) as Record<string, unknown>;
      return jsonResult({
        meta: dayKeyMeta(config.timezone, key),
        ...schedule,
      });
    },
  );

  server.tool(
    'get_day',
    'Routine items and statuses for one calendar day.',
    { dayKey: DAY_KEY.describe('YYYY-MM-DD') },
    async ({ dayKey }) => jsonResult(await api.getDay(dayKey)),
  );

  server.tool(
    'get_week_schedule',
    'Seven days (Mon–Sun) for the week containing startDayKey.',
    {
      startDayKey: DAY_KEY.optional().describe(
        'Any day in the target week; default is configured “today”',
      ),
    },
    async ({ startDayKey }) => jsonResult(await api.getWeek(startDayKey ?? resolveToday())),
  );

  server.tool(
    'list_routine_items',
    `Full weekly template (all routine items, ids + sortOrder). ${WEEKDAYS_HELP}`,
    {},
    async () => jsonResult(await api.listRoutineItems()),
  );

  server.tool(
    'upsert_routine_item',
    `Create/update/soft-delete a routine template item. Phone picks up after auto-sync (~45s), request_client_sync_nudge, or Sync now. ${WEEKDAYS_HELP}`,
    {
      id: z.string().min(1).max(64).optional().describe('Existing id to update; omit for new item'),
      title: z.string().min(1).max(120).optional(),
      sphere: z.enum(LIFE_SPHERES).optional(),
      weekdays: z.number().int().min(0).max(127).optional().describe(WEEKDAYS_HELP),
      sortOrder: z.number().int().min(0).max(9999).optional().describe('Order in Routine list'),
      effort: z.enum(['light', 'medium', 'heavy']).optional(),
      isOptional: z.boolean().optional(),
      scheduledMinuteOfDay: z.number().int().min(0).max(1439).nullable().optional(),
      delete: z.boolean().optional().describe('Soft-delete when true (id required)'),
    },
    async (args) => {
      if (args.delete) {
        if (!args.id) {
          throw new Error('id is required when delete is true');
        }
      } else if (!args.title || !args.sphere || args.weekdays == null) {
        throw new Error('title, sphere, and weekdays are required unless delete is true');
      }
      return jsonResult(await api.upsertRoutine(args));
    },
  );

  server.tool(
    'set_day_item_status',
    'Mark a routine item pending, done, or skipped on a specific day (Today checkboxes).',
    {
      dayKey: DAY_KEY,
      routineItemId: z.string().min(1).max(64),
      status: z.enum(DAY_STATUSES),
    },
    async (body) => jsonResult(await api.setDayItemStatus(body)),
  );

  server.tool(
    'list_weekly_goals',
    'Weekly goals for a week. weekKey is Monday yyyy-MM-dd (same as Week screen).',
    { weekKey: DAY_KEY.describe('Monday of the target week, or any day — use weekKeyFromDay helper') },
    async ({ weekKey }) => jsonResult(await api.listWeeklyGoals(weekKeyFromDayKey(weekKey))),
  );

  server.tool(
    'upsert_weekly_goal',
    'Create/update/soft-delete a weekly goal. weekKey = Monday yyyy-MM-dd.',
    {
      id: z.string().min(1).max(64).optional(),
      weekKey: DAY_KEY.optional(),
      title: z.string().min(1).max(120).optional(),
      sphere: z.enum(LIFE_SPHERES).optional(),
      targetCount: z.number().int().min(1).max(99).optional(),
      progressCount: z.number().int().min(0).max(99).optional(),
      status: z.enum(GOAL_STATUSES).optional(),
      delete: z.boolean().optional(),
    },
    async (args) => {
      if (args.delete) {
        if (!args.id) {
          throw new Error('id is required when delete is true');
        }
      } else if (!args.weekKey || !args.title || !args.sphere) {
        throw new Error('weekKey, title, and sphere are required unless delete is true');
      }
      const payload = { ...args };
      if (payload.weekKey) {
        payload.weekKey = weekKeyFromDayKey(payload.weekKey);
      }
      return jsonResult(await api.upsertWeeklyGoal(payload));
    },
  );

  server.tool(
    'get_user_stats',
    'XP, current/best streak, last green day (read-only).',
    {},
    async () => jsonResult(await api.getUserStats()),
  );

  server.tool(
    'get_daily_report',
    'Close-day report for a day (mood, tier, notes) or null if day not closed.',
    { dayKey: DAY_KEY },
    async ({ dayKey }) => {
      const report = await api.getDailyReport(dayKey);
      return jsonResult({ dayKey, report: report ?? null });
    },
  );

  server.tool(
    'close_day',
    'Close a calendar day (daily report + tier + XP + streak). Uses cloud routine statuses for that day. Fails with 409 if already closed. Cannot close future days. Phone syncs report via pull (~45s or nudge).',
    {
      dayKey: DAY_KEY.describe('YYYY-MM-DD to close (not in the future)'),
      noteHighlight: z.string().max(2000).describe('Short highlight (min 2 chars for green tier quality)'),
      noteReflection: z.string().max(4000).describe('Reflection (min 2 chars for green tier quality)'),
      mood: z.number().int().min(1).max(5).optional().describe('Optional mood 1–5'),
    },
    async ({ dayKey, noteHighlight, noteReflection, mood }) =>
      jsonResult(
        await api.closeDay({
          dayKey,
          noteHighlight,
          noteReflection,
          mood: mood ?? null,
        }),
      ),
  );

  server.tool(
    'get_weekly_report',
    'Weekly reflection notes (win/focus) for a week.',
    {
      weekKey: DAY_KEY.optional().describe('Monday yyyy-MM-dd; default = current week'),
    },
    async ({ weekKey }) =>
      jsonResult(await api.getWeeklyReport(weekKey ? weekKeyFromDayKey(weekKey) : undefined)),
  );

  server.tool(
    'get_cloud_revision',
    'Latest cloud updatedAt across your data — poll after writes until it advances.',
    {},
    async () => jsonResult(await api.getCloudRevision()),
  );

  server.tool(
    'request_client_sync_nudge',
    'Ask the phone to pull soon (sets steadyweek_mcp_nudge). Still allow ~45s or foreground sync; use Sync now for instant.',
    {},
    async () => jsonResult(await api.requestClientSyncNudge()),
  );

  server.tool(
    'wait_for_cloud_revision',
    'Poll get_cloud_revision until cloudUpdatedAt is >= minCloudUpdatedAt or timeout.',
    {
      minCloudUpdatedAt: z
        .string()
        .describe('ISO timestamp; wait until cloudUpdatedAt >= this value'),
      timeoutMs: z.number().int().min(1000).max(120_000).optional().default(30_000),
      intervalMs: z.number().int().min(500).max(10_000).optional().default(2000),
    },
    async ({ minCloudUpdatedAt, timeoutMs, intervalMs }) => {
      const minMs = Date.parse(minCloudUpdatedAt);
      if (Number.isNaN(minMs)) {
        throw new Error('Invalid minCloudUpdatedAt');
      }
      const deadline = Date.now() + timeoutMs;
      let last = await api.getCloudRevision();
      while (Date.parse(last.cloudUpdatedAt) < minMs && Date.now() < deadline) {
        await sleep(intervalMs);
        last = await api.getCloudRevision();
      }
      return jsonResult({
        reached: Date.parse(last.cloudUpdatedAt) >= minMs,
        revision: last,
      });
    },
  );
}

import type { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { z } from 'zod';
import type { SteadyWeekApi } from './api.js';

const DAY_KEY = z.string().regex(/^\d{4}-\d{2}-\d{2}$/);
const LIFE_SPHERES = ['work', 'body', 'social', 'rest', 'home', 'growth'] as const;

function localDayKey(): string {
  const now = new Date();
  const y = now.getFullYear();
  const m = String(now.getMonth() + 1).padStart(2, '0');
  const d = String(now.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function jsonResult(data: unknown) {
  return {
    content: [{ type: 'text' as const, text: JSON.stringify(data, null, 2) }],
  };
}

export function registerTools(server: McpServer, api: SteadyWeekApi) {
  server.tool(
    'get_today',
    'Today’s routine items and statuses from SteadyWeek cloud (Nest + Neon).',
    {
      dayKey: DAY_KEY.optional().describe(
        'Optional YYYY-MM-DD; default is your machine’s local today',
      ),
    },
    async ({ dayKey }) => jsonResult(await api.getDay(dayKey ?? localDayKey())),
  );

  server.tool(
    'get_day',
    'Routine items for a specific calendar day.',
    {
      dayKey: DAY_KEY.describe('YYYY-MM-DD'),
    },
    async ({ dayKey }) => jsonResult(await api.getDay(dayKey)),
  );

  server.tool(
    'get_week_schedule',
    'Seven days (Mon–Sun) starting from the week that contains startDayKey.',
    {
      startDayKey: DAY_KEY.optional().describe(
        'Any day in the target week; default local today',
      ),
    },
    async ({ startDayKey }) => jsonResult(await api.getWeek(startDayKey)),
  );

  server.tool(
    'upsert_routine_item',
    'Create or update a routine item in Neon via Nest. Phone picks it up after auto-sync (~45s) or Sync now.',
    {
      id: z.string().min(1).max(64).optional().describe('Existing id to update; omit for new item'),
      title: z.string().min(1).max(120).optional(),
      sphere: z
        .enum(LIFE_SPHERES)
        .optional()
        .describe('work | body | social | rest | home | growth'),
      weekdays: z
        .number()
        .int()
        .min(0)
        .max(127)
        .optional()
        .describe('Bitmask Mon=1 … Sun=64'),
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
}

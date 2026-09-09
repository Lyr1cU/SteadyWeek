import type { DayItemStatus, TodayRoutineRow } from '../domain/models';

/** Keep in sync with `backend/src/assistant/assistant-templates.ts`. */

export type TodayItemContext = {
  title: string;
  sphere: string;
  effort: string;
  status: DayItemStatus;
  isOptional: boolean;
};

const SUPPORTIVE = [
  'Even one small step counts. Pick the lightest item and start there.',
  'Balance beats perfection. Do what you can today.',
  'Your list is a guide, not a verdict. Keep it gentle.',
];

function pickRandom(options: string[]): string {
  return options[Math.floor(Math.random() * options.length)] ?? options[0]!;
}

export function todayRowsToContext(rows: TodayRoutineRow[]): TodayItemContext[] {
  return rows.map((row) => ({
    title: row.item.title,
    sphere: row.item.sphere,
    effort: row.item.effort,
    status: row.status,
    isOptional: row.item.isOptional,
  }));
}

export function pickAssistantTemplate(message: string, items: TodayItemContext[]): string {
  const lower = message.trim().toLowerCase();

  if (items.length === 0) {
    return 'Nothing scheduled for this day yet. Add items on the Routine tab.';
  }

  if (
    lower.includes('today') ||
    lower.includes('what') ||
    lower.includes('plan') ||
    lower.includes('schedule')
  ) {
    const lines = items
      .map((item) => `- ${item.title} (${item.status}, ${item.sphere})`)
      .join('\n');
    return `Today you have ${items.length} item(s):\n${lines}`;
  }

  const done = items.filter((item) => item.status === 'done').length;
  const pending = items.filter((item) => item.status === 'pending').length;
  const skipped = items.filter((item) => item.status === 'skipped').length;

  if (lower.includes('how') || lower.includes('progress') || lower.includes('doing')) {
    return `So far: ${done} done, ${pending} pending, ${skipped} skipped. One next step is enough.`;
  }

  if (lower.includes('next') || lower.includes('start')) {
    const next =
      items.find((item) => item.status === 'pending' && !item.isOptional) ??
      items.find((item) => item.status === 'pending');
    return next
      ? `Try starting with "${next.title}" (${next.effort} effort).`
      : pickRandom(SUPPORTIVE);
  }

  return pickRandom(SUPPORTIVE);
}

export const ASSISTANT_QUICK_PROMPTS = [
  "What's on today?",
  'How am I doing?',
  'What should I start with?',
] as const;

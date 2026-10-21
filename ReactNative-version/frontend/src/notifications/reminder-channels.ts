import type { ReminderPresentation } from './reminder-presentation';

export function routineChannelId(presentation: ReminderPresentation): string {
  return presentation === 'screen' ? 'routine_reminders_screen' : 'routine_reminders_exact';
}

export function closeDayChannelId(presentation: ReminderPresentation): string {
  return presentation === 'screen' ? 'close_day_screen' : 'close_day_exact';
}

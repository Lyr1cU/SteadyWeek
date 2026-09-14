/** English UI strings (v1). Ukrainian keys — phase 6 follow-up. */

export const en = {
  sync: {
    offline: 'Offline',
    syncing: 'Syncing…',
    synced: 'Synced',
    error: 'Sync error',
  },
  notifications: {
    closeDayTitle: 'SteadyWeek',
    closeDayBody: 'Take a minute to close your day and check in.',
  },
  assistant: {
    greeting:
      'Hi — ask about today’s routine. Offline or busy? I still answer from templates.',
    placeholder: 'Ask about today…',
    groqHint: 'Groq when online · templates as fallback',
    templateHint: 'Templates from your local today list · sign in for Groq',
  },
  profile: {
    reminderStatusOk: 'Daily reminder at 21:00 in the system shade.',
    testNotification: 'Test notification (5 sec)',
  },
  common: {
    back: 'Back',
    send: 'Send',
  },
} as const;

export type StringKey = keyof typeof en;

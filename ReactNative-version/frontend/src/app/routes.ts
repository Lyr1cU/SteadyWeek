export const shellTabs = [
  'today',
  'week',
  'routine',
  'profile',
] as const;

export type ShellTab = (typeof shellTabs)[number];

export type AppRoute =
  | { name: 'onboarding' }
  | { name: 'auth' }
  | { name: 'shell'; tab: ShellTab }
  | { name: 'closeDay'; dayKey: string }
  | { name: 'weeklyReport'; weekKey: string }
  | { name: 'shop' }
  | { name: 'assistant'; backTab: ShellTab; dayKey?: string };

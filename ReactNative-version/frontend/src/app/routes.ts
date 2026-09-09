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
  | { name: 'closeDay' }
  | { name: 'weeklyReport' }
  | { name: 'shop' }
  | { name: 'assistant'; backTab: ShellTab };

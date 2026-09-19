import type { DayTier } from '../domain/day-tier';

const greenLines = (streak: number) => [
  `Green day — streak ${streak}. Keep the rhythm.`,
  'Solid green. You showed up where it mattered.',
];

const yellowLines = [
  'Yellow day — partial win. Tomorrow is a clean slate.',
  'Not perfect, not empty. That counts.',
];

const redLines = [
  'Tough day. Rest, then one small step tomorrow.',
  'Red day logged. Be kind to yourself tonight.',
];

export function assistantAfterCloseDay(tier: DayTier, newStreak: number): string {
  const pool =
    tier === 'green' ? greenLines(newStreak) : tier === 'yellow' ? yellowLines : redLines;
  return pool[Math.floor(Math.random() * pool.length)] ?? pool[0];
}

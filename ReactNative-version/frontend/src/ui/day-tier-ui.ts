import type { DayTier } from '../domain/day-tier';

export function tierRimStyle(tier: DayTier): {
  backgroundColor: string;
  borderColor: string;
  accent: string;
} {
  if (tier === 'green') {
    return {
      backgroundColor: 'rgba(134, 239, 172, 0.1)',
      borderColor: 'rgba(134, 239, 172, 0.45)',
      accent: 'rgba(134, 239, 172, 0.95)',
    };
  }
  if (tier === 'yellow') {
    return {
      backgroundColor: 'rgba(252, 211, 77, 0.1)',
      borderColor: 'rgba(252, 211, 77, 0.42)',
      accent: 'rgba(252, 211, 77, 0.95)',
    };
  }
  return {
    backgroundColor: 'rgba(252, 165, 165, 0.1)',
    borderColor: 'rgba(252, 165, 165, 0.42)',
    accent: 'rgba(252, 165, 165, 0.95)',
  };
}

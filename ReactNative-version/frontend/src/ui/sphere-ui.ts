import type { LifeSphereId } from '../domain/life-sphere';

const SPHERE_LABELS: Record<LifeSphereId, string> = {
  work: 'Work',
  body: 'Body',
  social: 'Social',
  rest: 'Rest',
  home: 'Home',
  growth: 'Growth',
};

/** Single-char markers for Today cards (no icon font — avoids Metro/@expo/vector-icons issues). */
const SPHERE_SYMBOLS: Record<LifeSphereId, string> = {
  work: '◈',
  body: '♡',
  social: '◎',
  rest: '☾',
  home: '⌂',
  growth: '✦',
};

export function sphereLabel(sphere: string): string {
  if (sphere in SPHERE_LABELS) {
    return SPHERE_LABELS[sphere as LifeSphereId];
  }
  return sphere;
}

export function sphereSymbol(sphere: string): string {
  if (sphere in SPHERE_SYMBOLS) {
    return SPHERE_SYMBOLS[sphere as LifeSphereId];
  }
  return '•';
}

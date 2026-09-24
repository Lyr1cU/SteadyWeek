export const TAB_BAR_CLEARANCE = 118;

export const durationScreen = 280;
export const durationTab = 200;
export const durationPress = 120;
export const durationModal = 260;

export const staggerStep = 40;
export const staggerIndexCap = 8;

export const pressScale = 0.96;
export const pressOpacity = 0.92;

export function staggerDelay(index: number, reduceMotion: boolean): number {
  if (reduceMotion) {
    return 0;
  }
  return Math.min(index, staggerIndexCap) * staggerStep;
}

export function motionDuration(base: number, reduceMotion: boolean): number {
  return reduceMotion ? 0 : base;
}

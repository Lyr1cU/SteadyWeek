/** Keep in sync with `frontend/src/domain/life-sphere.ts` and `domain/models.ts` Effort. */
export const LIFE_SPHERES = [
  'work',
  'body',
  'social',
  'rest',
  'home',
  'growth',
] as const;

export const EFFORTS = ['light', 'medium', 'heavy'] as const;

export type LifeSphere = (typeof LIFE_SPHERES)[number];
export type Effort = (typeof EFFORTS)[number];

/** IDs from MASTER_PLAN §2. Add a sphere here; UI maps labels separately. */
export const LIFE_SPHERES = [
  'work',
  'body',
  'social',
  'rest',
  'home',
  'growth',
] as const;

export type LifeSphereId = (typeof LIFE_SPHERES)[number];

export function isLifeSphereId(value: string): value is LifeSphereId {
  return (LIFE_SPHERES as readonly string[]).includes(value);
}

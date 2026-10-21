/** Same rules as Flutter `compareRoutineSchedule` — time first, then manual order; null time last. */
export function compareRoutineSchedule(
  minuteA: number | null,
  orderA: number,
  minuteB: number | null,
  orderB: number,
): number {
  if (minuteA != null && minuteB != null && minuteA !== minuteB) {
    return minuteA - minuteB;
  }
  if (minuteA == null && minuteB != null) {
    return 1;
  }
  if (minuteA != null && minuteB == null) {
    return -1;
  }
  return orderA - orderB;
}

export function compareRoutineItems(a: { order: number; scheduledMinuteOfDay: number | null }, b: {
  order: number;
  scheduledMinuteOfDay: number | null;
}): number {
  return compareRoutineSchedule(
    a.scheduledMinuteOfDay,
    a.order,
    b.scheduledMinuteOfDay,
    b.order,
  );
}

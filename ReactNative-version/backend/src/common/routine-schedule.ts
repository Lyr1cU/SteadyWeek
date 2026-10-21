/** Matches Flutter / RN client — scheduled time first, then sortOrder; flexible time last. */
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

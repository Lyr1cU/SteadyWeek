export function parseDate(value: string | null | undefined): Date | null {
  if (!value) {
    return null;
  }
  return new Date(value);
}

export function mapRoutine(row: {
  id: string;
  title: string;
  sphere: string;
  weekdays: number;
  sortOrder: number;
  effort: string;
  isOptional: boolean;
  scheduledMinuteOfDay: number | null;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}) {
  return {
    id: row.id,
    title: row.title,
    sphere: row.sphere,
    weekdays: row.weekdays,
    sortOrder: row.sortOrder,
    effort: row.effort,
    isOptional: row.isOptional,
    scheduledMinuteOfDay: row.scheduledMinuteOfDay,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
    deletedAt: row.deletedAt?.toISOString() ?? null,
  };
}

export function mapDayStatus(row: {
  dayKey: string;
  routineItemId: string;
  status: string;
  updatedAt: Date;
}) {
  return {
    dayKey: row.dayKey,
    routineItemId: row.routineItemId,
    status: row.status,
    updatedAt: row.updatedAt.toISOString(),
  };
}

export function mapSetting(row: { key: string; value: string; updatedAt: Date }) {
  return {
    key: row.key,
    value: row.value,
    updatedAt: row.updatedAt.toISOString(),
  };
}

export function mapStats(row: {
  totalXp: number;
  currentStreak: number;
  bestStreak: number;
  lastGreenDayKey: string | null;
  updatedAt: Date;
}) {
  return {
    totalXp: row.totalXp,
    currentStreak: row.currentStreak,
    bestStreak: row.bestStreak,
    lastGreenDayKey: row.lastGreenDayKey,
    updatedAt: row.updatedAt.toISOString(),
  };
}

export function mapWeeklyGoal(row: {
  id: string;
  weekKey: string;
  sphere: string;
  title: string;
  targetCount: number;
  progressCount: number;
  status: string;
  updatedAt: Date;
  deletedAt: Date | null;
}) {
  return {
    id: row.id,
    weekKey: row.weekKey,
    sphere: row.sphere,
    title: row.title,
    targetCount: row.targetCount,
    progressCount: row.progressCount,
    status: row.status,
    updatedAt: row.updatedAt.toISOString(),
    deletedAt: row.deletedAt?.toISOString() ?? null,
  };
}

export function mapDailyReport(row: {
  dayKey: string;
  mood: number | null;
  noteHighlight: string;
  noteReflection: string;
  dayTier: string;
  xpAwarded: number;
  closedAt: Date;
  updatedAt: Date;
}) {
  return {
    dayKey: row.dayKey,
    mood: row.mood,
    noteHighlight: row.noteHighlight,
    noteReflection: row.noteReflection,
    dayTier: row.dayTier,
    xpAwarded: row.xpAwarded,
    closedAt: row.closedAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

export function mapWeeklyReport(row: {
  weekKey: string;
  noteWin: string;
  noteFocus: string;
  updatedAt: Date;
}) {
  return {
    weekKey: row.weekKey,
    noteWin: row.noteWin,
    noteFocus: row.noteFocus,
    updatedAt: row.updatedAt.toISOString(),
  };
}

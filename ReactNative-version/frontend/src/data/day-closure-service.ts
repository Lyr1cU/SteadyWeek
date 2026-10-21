import type { SQLiteDatabase } from 'expo-sqlite';
import { weekKeyFromDate } from '../logic/calendar';
import { xpForClosedDay } from '../logic/close-day-xp';
import { evaluateDay } from '../logic/evaluate-day';
import { createSqliteGoalsRepository } from './sqlite/goals-repository';
import { createSqliteRoutineRepository } from './sqlite/routine-repository';
import {
  DayAlreadyClosedError,
  FutureDayCloseError,
  type CloseDayOutcome,
} from './close-day/close-day-errors';
import { normalizeCloseInput } from './close-day/normalize-close-input';
import { persistClosedDay } from './close-day/persist-closed-day';

export { DayAlreadyClosedError, FutureDayCloseError, type CloseDayOutcome };

export function createDayClosureService(db: SQLiteDatabase) {
  const routine = createSqliteRoutineRepository(db);
  const goals = createSqliteGoalsRepository(db);

  return {
    async submit(input: {
      date: Date;
      noteHighlight: string;
      noteReflection: string;
      mood: number | null;
    }): Promise<CloseDayOutcome> {
      const normalized = normalizeCloseInput(input);
      const rows = await routine.loadTodayRows(input.date);
      const weeklyGoals = await goals.listForWeek(weekKeyFromDate(input.date));
      const evaluation = evaluateDay({
        rows,
        noteHighlight: normalized.noteHighlight,
        noteReflection: normalized.noteReflection,
        mood: normalized.mood,
        weeklyGoals,
      });

      return persistClosedDay(db, {
        dayKey: normalized.dayKey,
        mood: normalized.mood,
        noteHighlight: normalized.noteHighlight,
        noteReflection: normalized.noteReflection,
        tier: evaluation.tier,
        xpAwarded: xpForClosedDay(rows, evaluation.tier),
        workImbalance: evaluation.workImbalance,
      });
    },
  };
}

export type DayClosureService = ReturnType<typeof createDayClosureService>;

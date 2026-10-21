import { dateKey } from '../../logic/calendar';
import { FutureDayCloseError } from './close-day-errors';

const HIGHLIGHT_MAX = 2000;
const REFLECTION_MAX = 4000;

export type NormalizedCloseInput = {
  dayKey: string;
  mood: number | null;
  noteHighlight: string;
  noteReflection: string;
};

function clampMood(mood: number | null): number | null {
  if (mood == null) {
    return null;
  }
  if (!Number.isInteger(mood) || mood < 1 || mood > 5) {
    return null;
  }
  return mood;
}

export function normalizeCloseInput(input: {
  date: Date;
  noteHighlight: string;
  noteReflection: string;
  mood: number | null;
}): NormalizedCloseInput {
  const dayKey = dateKey(input.date);
  const todayKey = dateKey(new Date());
  if (dayKey > todayKey) {
    throw new FutureDayCloseError(dayKey);
  }

  return {
    dayKey,
    mood: clampMood(input.mood),
    noteHighlight: input.noteHighlight.trim().slice(0, HIGHLIGHT_MAX),
    noteReflection: input.noteReflection.trim().slice(0, REFLECTION_MAX),
  };
}

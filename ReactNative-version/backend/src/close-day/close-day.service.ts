import {
  BadRequestException,
  ConflictException,
  Injectable,
} from '@nestjs/common';
import { formatDayKey, startOfWeekMonday } from '../common/calendar';
import { parseDayKey } from '../assistant/weekdays';
import { PrismaService } from '../prisma/prisma.service';
import { ScheduleService } from '../schedule/schedule.service';
import { mapDailyReport, mapStats } from '../sync/sync.mapper';
import { WeeklyGoalsService } from '../weekly-goals/weekly-goals.service';
import { evaluateDay, xpForClosedDay } from './close-day-logic';
import type { CloseDayDto } from './close-day.dto';
import { computeStreakFromClosedDayKeys } from './streak';

const HIGHLIGHT_MAX = 2000;
const REFLECTION_MAX = 4000;

function clampMood(mood: number | null | undefined): number | null {
  if (mood == null) {
    return null;
  }
  if (!Number.isInteger(mood) || mood < 1 || mood > 5) {
    return null;
  }
  return mood;
}

@Injectable()
export class CloseDayService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schedule: ScheduleService,
    private readonly weeklyGoals: WeeklyGoalsService,
  ) {}

  async close(userId: string, dto: CloseDayDto) {
    const dayKey = dto.dayKey;
    const todayKey = formatDayKey(new Date());
    if (dayKey > todayKey) {
      throw new BadRequestException(`Cannot close a future day: ${dayKey}`);
    }

    const existing = await this.prisma.dailyReport.findUnique({
      where: { userId_dayKey: { userId, dayKey } },
    });
    if (existing) {
      throw new ConflictException(`Day already closed: ${dayKey}`);
    }

    const mood = clampMood(dto.mood ?? null);
    const noteHighlight = dto.noteHighlight.trim().slice(0, HIGHLIGHT_MAX);
    const noteReflection = dto.noteReflection.trim().slice(0, REFLECTION_MAX);

    const day = await this.schedule.getDay(userId, dayKey);
    const weekKey = formatDayKey(startOfWeekMonday(parseDayKey(dayKey)));
    const goals = await this.weeklyGoals.listForWeek(userId, weekKey);

    const evaluation = evaluateDay({
      rows: day.items.map((item) => ({
        status: item.status,
        isOptional: item.isOptional,
        sphere: item.sphere,
        effort: item.effort,
      })),
      noteHighlight,
      noteReflection,
      mood,
      weeklyGoals: goals.map((g) => ({ sphere: g.sphere, status: g.status })),
    });

    const xpAwarded = xpForClosedDay(
      day.items.map((item) => ({
        status: item.status,
        effort: item.effort,
        isOptional: item.isOptional,
      })),
      evaluation.tier,
    );

    const closedAt = new Date();
    const updatedAt = closedAt;

    const result = await this.prisma.$transaction(async (tx) => {
      await tx.dailyReport.create({
        data: {
          userId,
          dayKey,
          mood,
          noteHighlight,
          noteReflection,
          dayTier: evaluation.tier,
          xpAwarded,
          workImbalance: evaluation.workImbalance,
          closedAt,
          updatedAt,
        },
      });

      const closedRows = await tx.dailyReport.findMany({
        where: { userId },
        select: { dayKey: true },
      });
      const streak = computeStreakFromClosedDayKeys(closedRows.map((r) => r.dayKey));

      const statsRow = await tx.userStats.findUnique({ where: { userId } });
      const prevTotal = statsRow?.totalXp ?? 0;
      const newTotal = prevTotal + xpAwarded;
      const newBest = Math.max(statsRow?.bestStreak ?? 0, streak.currentStreak);

      const stats = await tx.userStats.upsert({
        where: { userId },
        create: {
          userId,
          totalXp: newTotal,
          currentStreak: streak.currentStreak,
          bestStreak: newBest,
          lastGreenDayKey: streak.lastGreenDayKey,
          updatedAt,
        },
        update: {
          totalXp: newTotal,
          currentStreak: streak.currentStreak,
          bestStreak: newBest,
          lastGreenDayKey: streak.lastGreenDayKey,
          updatedAt,
        },
      });

      const report = await tx.dailyReport.findUniqueOrThrow({
        where: { userId_dayKey: { userId, dayKey } },
      });

      return {
        xpAwarded,
        tier: evaluation.tier,
        newStreak: streak.currentStreak,
        newTotalXp: newTotal,
        report: mapDailyReport(report),
        userStats: mapStats(stats),
        evaluation: {
          routineCompletionRate: evaluation.routineCompletionRate,
          distinctSpheres: evaluation.distinctSpheres,
          workImbalance: evaluation.workImbalance,
          reportQualityOk: evaluation.reportQualityOk,
        },
      };
    });

    return result;
  }
}

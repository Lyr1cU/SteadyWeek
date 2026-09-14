import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { parseDayKey, routineRunsOnDate } from '../assistant/weekdays';
import { addDays, formatDayKey, startOfWeekMonday } from '../common/calendar';
import type { ScheduleDayResponse, ScheduleWeekResponse } from './schedule.dto';

type RoutineRow = {
  id: string;
  title: string;
  sphere: string;
  effort: string;
  weekdays: number;
  isOptional: boolean;
  scheduledMinuteOfDay: number | null;
};

@Injectable()
export class ScheduleService {
  constructor(private readonly prisma: PrismaService) {}

  todayKeyLocal(): string {
    return formatDayKey(new Date());
  }

  async getDay(userId: string, dayKey: string): Promise<ScheduleDayResponse> {
    let date: Date;
    try {
      date = parseDayKey(dayKey);
    } catch {
      throw new BadRequestException('Invalid dayKey');
    }

    const [routines, statuses] = await Promise.all([
      this.prisma.routineItem.findMany({
        where: { userId, deletedAt: null },
        orderBy: [{ sortOrder: 'asc' }, { title: 'asc' }],
      }),
      this.prisma.dayItemStatus.findMany({
        where: { userId, dayKey },
      }),
    ]);

    return this.assembleDay(dayKey, date, routines, statuses);
  }

  async getWeek(userId: string, startDayKey?: string): Promise<ScheduleWeekResponse> {
    const anchorKey = startDayKey ?? this.todayKeyLocal();
    let anchor: Date;
    try {
      anchor = parseDayKey(anchorKey);
    } catch {
      throw new BadRequestException('Invalid startDayKey');
    }

    const monday = startOfWeekMonday(anchor);
    const dayKeys = Array.from({ length: 7 }, (_, i) => formatDayKey(addDays(monday, i)));

    const [routines, statuses] = await Promise.all([
      this.prisma.routineItem.findMany({
        where: { userId, deletedAt: null },
        orderBy: [{ sortOrder: 'asc' }, { title: 'asc' }],
      }),
      this.prisma.dayItemStatus.findMany({
        where: { userId, dayKey: { in: dayKeys } },
      }),
    ]);

    const days = dayKeys.map((dayKey) => {
      const date = parseDayKey(dayKey);
      const dayStatuses = statuses.filter((row) => row.dayKey === dayKey);
      return this.assembleDay(dayKey, date, routines, dayStatuses);
    });

    return {
      weekStart: formatDayKey(monday),
      days,
    };
  }

  private assembleDay(
    dayKey: string,
    date: Date,
    routines: RoutineRow[],
    statuses: { routineItemId: string; status: string }[],
  ): ScheduleDayResponse {
    const statusByItemId = new Map(statuses.map((row) => [row.routineItemId, row.status]));
    return {
      dayKey,
      items: routines
        .filter((row) => routineRunsOnDate(row.weekdays, date))
        .map((row) => ({
          id: row.id,
          title: row.title,
          sphere: row.sphere,
          effort: row.effort,
          status: statusByItemId.get(row.id) ?? 'pending',
          isOptional: row.isOptional,
          scheduledMinuteOfDay: row.scheduledMinuteOfDay,
        })),
    };
  }
}

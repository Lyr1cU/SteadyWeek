import { Injectable } from '@nestjs/common';
import { formatDayKey, startOfWeekMonday } from '../common/calendar';
import { PrismaService } from '../prisma/prisma.service';
import { mapDailyReport, mapStats, mapWeeklyReport } from '../sync/sync.mapper';

@Injectable()
export class InsightsService {
  constructor(private readonly prisma: PrismaService) {}

  async getUserStats(userId: string) {
    const row = await this.prisma.userStats.findUnique({ where: { userId } });
    if (!row) {
      return {
        totalXp: 0,
        currentStreak: 0,
        bestStreak: 0,
        lastGreenDayKey: null,
        updatedAt: null,
      };
    }
    return mapStats(row);
  }

  async getDailyReport(userId: string, dayKey: string) {
    const row = await this.prisma.dailyReport.findUnique({
      where: { userId_dayKey: { userId, dayKey } },
    });
    if (!row) {
      return null;
    }
    return mapDailyReport(row);
  }

  async getWeeklyReport(userId: string, weekKey?: string) {
    const key = weekKey ?? formatDayKey(startOfWeekMonday(new Date()));
    const row = await this.prisma.weeklyReport.findUnique({
      where: { userId_weekKey: { userId, weekKey: key } },
    });
    if (!row) {
      return { weekKey: key, noteWin: '', noteFocus: '', updatedAt: null };
    }
    return mapWeeklyReport(row);
  }
}

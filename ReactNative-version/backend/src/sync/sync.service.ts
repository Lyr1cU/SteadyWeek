import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  mapDayStatus,
  mapDailyReport,
  mapRoutine,
  mapSetting,
  mapStats,
  mapWeeklyGoal,
  mapWeeklyReport,
  parseDate,
} from './sync.mapper';
import type {
  AppSettingDto,
  DailyReportDto,
  DayItemStatusDto,
  RoutineItemDto,
  SyncPushDto,
  UserStatsDto,
  WeeklyGoalDto,
  WeeklyReportDto,
} from './sync.dto';

/** Skip push only when server row is strictly newer (LWW). Equal timestamps accept incoming. */
function isStalePush(incomingAt: Date, existingUpdatedAt: Date | undefined): boolean {
  return existingUpdatedAt != null && existingUpdatedAt > incomingAt;
}

@Injectable()
export class SyncService {
  constructor(private readonly prisma: PrismaService) {}

  async pull(userId: string, since: Date) {
    const [
      routineItems,
      dayItemStatus,
      appSettings,
      userStats,
      weeklyGoals,
      dailyReports,
      weeklyReports,
    ] = await Promise.all([
      this.prisma.routineItem.findMany({
        where: { userId, updatedAt: { gt: since } },
        orderBy: { updatedAt: 'asc' },
      }),
      this.prisma.dayItemStatus.findMany({
        where: { userId, updatedAt: { gt: since } },
        orderBy: { updatedAt: 'asc' },
      }),
      this.prisma.appSetting.findMany({
        where: { userId, updatedAt: { gt: since } },
        orderBy: { updatedAt: 'asc' },
      }),
      this.prisma.userStats.findUnique({ where: { userId } }),
      this.prisma.weeklyGoal.findMany({
        where: { userId, updatedAt: { gt: since } },
        orderBy: { updatedAt: 'asc' },
      }),
      this.prisma.dailyReport.findMany({
        where: { userId, updatedAt: { gt: since } },
        orderBy: { updatedAt: 'asc' },
      }),
      this.prisma.weeklyReport.findMany({
        where: { userId, updatedAt: { gt: since } },
        orderBy: { updatedAt: 'asc' },
      }),
    ]);

    return {
      routineItems: routineItems.map(mapRoutine),
      dayItemStatus: dayItemStatus.map(mapDayStatus),
      appSettings: appSettings.map(mapSetting),
      userStats: userStats && userStats.updatedAt > since ? mapStats(userStats) : null,
      weeklyGoals: weeklyGoals.map(mapWeeklyGoal),
      dailyReports: dailyReports.map(mapDailyReport),
      weeklyReports: weeklyReports.map(mapWeeklyReport),
      serverTime: new Date().toISOString(),
    };
  }

  async push(userId: string, dto: SyncPushDto) {
    for (const item of dto.routineItems) {
      await this.upsertRoutine(userId, item);
    }
    for (const row of dto.dayItemStatus) {
      await this.upsertDayStatus(userId, row);
    }
    for (const row of dto.appSettings) {
      await this.upsertSetting(userId, row);
    }
    if (dto.userStats) {
      await this.upsertStats(userId, dto.userStats);
    }
    for (const goal of dto.weeklyGoals ?? []) {
      await this.upsertWeeklyGoal(userId, goal);
    }
    for (const report of dto.dailyReports ?? []) {
      await this.upsertDailyReport(userId, report);
    }
    for (const report of dto.weeklyReports ?? []) {
      await this.upsertWeeklyReport(userId, report);
    }

    return { ok: true, serverTime: new Date().toISOString() };
  }

  private async upsertRoutine(userId: string, item: RoutineItemDto) {
    const incomingAt = new Date(item.updatedAt);
    const existing = await this.prisma.routineItem.findUnique({ where: { id: item.id } });
    if (existing && existing.userId !== userId) {
      return;
    }
    if (isStalePush(incomingAt, existing?.updatedAt)) {
      return;
    }

    await this.prisma.routineItem.upsert({
      where: { id: item.id },
      create: {
        id: item.id,
        userId,
        title: item.title,
        sphere: item.sphere,
        weekdays: item.weekdays,
        sortOrder: item.sortOrder,
        effort: item.effort,
        isOptional: item.isOptional,
        scheduledMinuteOfDay: item.scheduledMinuteOfDay,
        createdAt: new Date(item.createdAt),
        updatedAt: incomingAt,
        deletedAt: parseDate(item.deletedAt),
      },
      update: {
        title: item.title,
        sphere: item.sphere,
        weekdays: item.weekdays,
        sortOrder: item.sortOrder,
        effort: item.effort,
        isOptional: item.isOptional,
        scheduledMinuteOfDay: item.scheduledMinuteOfDay,
        updatedAt: incomingAt,
        deletedAt: parseDate(item.deletedAt),
      },
    });
  }

  private async upsertDayStatus(userId: string, row: DayItemStatusDto) {
    const incomingAt = new Date(row.updatedAt);
    const existing = await this.prisma.dayItemStatus.findUnique({
      where: {
        userId_dayKey_routineItemId: {
          userId,
          dayKey: row.dayKey,
          routineItemId: row.routineItemId,
        },
      },
    });
    if (isStalePush(incomingAt, existing?.updatedAt)) {
      return;
    }

    await this.prisma.dayItemStatus.upsert({
      where: {
        userId_dayKey_routineItemId: {
          userId,
          dayKey: row.dayKey,
          routineItemId: row.routineItemId,
        },
      },
      create: {
        userId,
        dayKey: row.dayKey,
        routineItemId: row.routineItemId,
        status: row.status,
        updatedAt: incomingAt,
      },
      update: {
        status: row.status,
        updatedAt: incomingAt,
      },
    });
  }

  private async upsertSetting(userId: string, row: AppSettingDto) {
    const incomingAt = new Date(row.updatedAt);
    const existing = await this.prisma.appSetting.findUnique({
      where: { userId_key: { userId, key: row.key } },
    });
    if (isStalePush(incomingAt, existing?.updatedAt)) {
      return;
    }

    await this.prisma.appSetting.upsert({
      where: { userId_key: { userId, key: row.key } },
      create: {
        userId,
        key: row.key,
        value: row.value,
        updatedAt: incomingAt,
      },
      update: {
        value: row.value,
        updatedAt: incomingAt,
      },
    });
  }

  private async upsertStats(userId: string, row: UserStatsDto) {
    const incomingAt = new Date(row.updatedAt);
    const existing = await this.prisma.userStats.findUnique({ where: { userId } });
    if (isStalePush(incomingAt, existing?.updatedAt)) {
      return;
    }

    await this.prisma.userStats.upsert({
      where: { userId },
      create: {
        userId,
        totalXp: row.totalXp,
        currentStreak: row.currentStreak,
        bestStreak: row.bestStreak,
        lastGreenDayKey: row.lastGreenDayKey,
        updatedAt: incomingAt,
      },
      update: {
        totalXp: row.totalXp,
        currentStreak: row.currentStreak,
        bestStreak: row.bestStreak,
        lastGreenDayKey: row.lastGreenDayKey,
        updatedAt: incomingAt,
      },
    });
  }

  private async upsertWeeklyGoal(userId: string, goal: WeeklyGoalDto) {
    const incomingAt = new Date(goal.updatedAt);
    const existing = await this.prisma.weeklyGoal.findUnique({ where: { id: goal.id } });
    if (existing && existing.userId !== userId) {
      return;
    }
    if (isStalePush(incomingAt, existing?.updatedAt)) {
      return;
    }

    await this.prisma.weeklyGoal.upsert({
      where: { id: goal.id },
      create: {
        id: goal.id,
        userId,
        weekKey: goal.weekKey,
        sphere: goal.sphere,
        title: goal.title,
        targetCount: goal.targetCount,
        progressCount: goal.progressCount,
        status: goal.status,
        updatedAt: incomingAt,
        deletedAt: parseDate(goal.deletedAt),
      },
      update: {
        weekKey: goal.weekKey,
        sphere: goal.sphere,
        title: goal.title,
        targetCount: goal.targetCount,
        progressCount: goal.progressCount,
        status: goal.status,
        updatedAt: incomingAt,
        deletedAt: parseDate(goal.deletedAt),
      },
    });
  }

  private async upsertDailyReport(userId: string, report: DailyReportDto) {
    const incomingAt = new Date(report.updatedAt);
    const existing = await this.prisma.dailyReport.findUnique({
      where: { userId_dayKey: { userId, dayKey: report.dayKey } },
    });
    if (isStalePush(incomingAt, existing?.updatedAt)) {
      return;
    }

    const workImbalance = report.workImbalance ?? false;

    await this.prisma.dailyReport.upsert({
      where: { userId_dayKey: { userId, dayKey: report.dayKey } },
      create: {
        userId,
        dayKey: report.dayKey,
        mood: report.mood,
        noteHighlight: report.noteHighlight,
        noteReflection: report.noteReflection,
        dayTier: report.dayTier,
        xpAwarded: report.xpAwarded,
        workImbalance,
        closedAt: new Date(report.closedAt),
        updatedAt: incomingAt,
      },
      update: {
        mood: report.mood,
        noteHighlight: report.noteHighlight,
        noteReflection: report.noteReflection,
        dayTier: report.dayTier,
        xpAwarded: report.xpAwarded,
        workImbalance,
        closedAt: new Date(report.closedAt),
        updatedAt: incomingAt,
      },
    });
  }

  private async upsertWeeklyReport(userId: string, report: WeeklyReportDto) {
    const incomingAt = new Date(report.updatedAt);
    const existing = await this.prisma.weeklyReport.findUnique({
      where: { userId_weekKey: { userId, weekKey: report.weekKey } },
    });
    if (isStalePush(incomingAt, existing?.updatedAt)) {
      return;
    }

    await this.prisma.weeklyReport.upsert({
      where: { userId_weekKey: { userId, weekKey: report.weekKey } },
      create: {
        userId,
        weekKey: report.weekKey,
        noteWin: report.noteWin,
        noteFocus: report.noteFocus,
        updatedAt: incomingAt,
      },
      update: {
        noteWin: report.noteWin,
        noteFocus: report.noteFocus,
        updatedAt: incomingAt,
      },
    });
  }
}

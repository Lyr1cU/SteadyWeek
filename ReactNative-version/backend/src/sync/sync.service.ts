import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  mapDayStatus,
  mapRoutine,
  mapSetting,
  mapStats,
  parseDate,
} from './sync.mapper';
import type {
  AppSettingDto,
  DayItemStatusDto,
  RoutineItemDto,
  SyncPushDto,
  UserStatsDto,
} from './sync.dto';

/** Skip push only when server row is strictly newer (LWW). Equal timestamps accept incoming. */
function isStalePush(incomingAt: Date, existingUpdatedAt: Date | undefined): boolean {
  return existingUpdatedAt != null && existingUpdatedAt > incomingAt;
}

@Injectable()
export class SyncService {
  constructor(private readonly prisma: PrismaService) {}

  async pull(userId: string, since: Date) {
    const [routineItems, dayItemStatus, appSettings, userStats] = await Promise.all([
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
    ]);

    return {
      routineItems: routineItems.map(mapRoutine),
      dayItemStatus: dayItemStatus.map(mapDayStatus),
      appSettings: appSettings.map(mapSetting),
      userStats: userStats && userStats.updatedAt > since ? mapStats(userStats) : null,
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
}

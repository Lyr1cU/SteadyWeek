import { BadRequestException, Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { PrismaService } from '../prisma/prisma.service';
import { mapWeeklyGoal } from '../sync/sync.mapper';
import type { UpsertWeeklyGoalDto } from './weekly-goals.dto';

@Injectable()
export class WeeklyGoalsService {
  constructor(private readonly prisma: PrismaService) {}

  async listForWeek(userId: string, weekKey: string) {
    const rows = await this.prisma.weeklyGoal.findMany({
      where: { userId, weekKey, deletedAt: null },
      orderBy: [{ updatedAt: 'asc' }, { title: 'asc' }],
    });
    return rows.map(mapWeeklyGoal);
  }

  async upsert(userId: string, dto: UpsertWeeklyGoalDto) {
    const now = new Date();

    if (dto.delete) {
      const id = dto.id?.trim();
      if (!id) {
        throw new BadRequestException('id required to delete');
      }
      const existing = await this.prisma.weeklyGoal.findUnique({ where: { id } });
      if (!existing || existing.userId !== userId) {
        throw new BadRequestException('Weekly goal not found');
      }
      const row = await this.prisma.weeklyGoal.update({
        where: { id },
        data: { deletedAt: now, updatedAt: now },
      });
      return mapWeeklyGoal(row);
    }

    const id = dto.id?.trim() || randomUUID();
    const title = dto.title?.trim() ?? '';
    if (!title || !dto.weekKey || dto.sphere == null) {
      throw new BadRequestException('weekKey, title, and sphere are required');
    }

    const existing = await this.prisma.weeklyGoal.findUnique({ where: { id } });
    if (existing && existing.userId !== userId) {
      throw new BadRequestException('Weekly goal not found');
    }

    const targetCount = dto.targetCount ?? existing?.targetCount ?? 1;
    let progressCount = dto.progressCount ?? existing?.progressCount ?? 0;
    progressCount = Math.min(Math.max(0, progressCount), targetCount);

    let status = dto.status ?? existing?.status ?? 'active';
    if (progressCount >= targetCount) {
      status = 'completed';
    } else if (status === 'completed') {
      status = 'active';
    }

    const row = await this.prisma.weeklyGoal.upsert({
      where: { id },
      create: {
        id,
        userId,
        weekKey: dto.weekKey,
        sphere: dto.sphere,
        title,
        targetCount,
        progressCount,
        status,
        updatedAt: now,
        deletedAt: null,
      },
      update: {
        weekKey: dto.weekKey,
        sphere: dto.sphere,
        title,
        targetCount,
        progressCount,
        status,
        updatedAt: now,
        deletedAt: null,
      },
    });

    return mapWeeklyGoal(row);
  }
}

import { BadRequestException, Injectable } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { PrismaService } from '../prisma/prisma.service';
import type { UpsertRoutineItemDto } from './routine.dto';

@Injectable()
export class RoutineService {
  constructor(private readonly prisma: PrismaService) {}

  async list(userId: string) {
    const rows = await this.prisma.routineItem.findMany({
      where: { userId, deletedAt: null },
      orderBy: [{ sortOrder: 'asc' }, { title: 'asc' }],
    });
    return rows.map((row) => this.mapRow(row));
  }

  async upsert(userId: string, dto: UpsertRoutineItemDto) {
    const now = new Date();

    if (dto.delete) {
      const id = dto.id?.trim();
      if (!id) {
        throw new BadRequestException('id required to delete');
      }
      const existing = await this.prisma.routineItem.findUnique({ where: { id } });
      if (!existing || existing.userId !== userId) {
        throw new BadRequestException('Routine item not found');
      }
      const row = await this.prisma.routineItem.update({
        where: { id },
        data: { deletedAt: now, updatedAt: now },
      });
      return this.mapRow(row);
    }

    const id = dto.id?.trim() || randomUUID();
    const title = dto.title?.trim() ?? '';
    if (!title || dto.sphere == null || dto.weekdays == null) {
      throw new BadRequestException('title, sphere, and weekdays are required');
    }

    const existing = await this.prisma.routineItem.findUnique({ where: { id } });
    if (existing && existing.userId !== userId) {
      throw new BadRequestException('Routine item not found');
    }

    let sortOrder = dto.sortOrder;
    if (sortOrder == null) {
      if (existing) {
        sortOrder = existing.sortOrder;
      } else {
        const max = await this.prisma.routineItem.aggregate({
          where: { userId, deletedAt: null },
          _max: { sortOrder: true },
        });
        sortOrder = (max._max.sortOrder ?? -1) + 1;
      }
    }

    const effort = dto.effort ?? existing?.effort ?? 'medium';
    const isOptional = dto.isOptional ?? existing?.isOptional ?? false;
    const scheduledMinuteOfDay =
      dto.scheduledMinuteOfDay !== undefined
        ? dto.scheduledMinuteOfDay
        : (existing?.scheduledMinuteOfDay ?? null);

    const row = await this.prisma.routineItem.upsert({
      where: { id },
      create: {
        id,
        userId,
        title,
        sphere: dto.sphere,
        weekdays: dto.weekdays,
        sortOrder,
        effort,
        isOptional,
        scheduledMinuteOfDay,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
      },
      update: {
        title,
        sphere: dto.sphere,
        weekdays: dto.weekdays,
        sortOrder,
        effort,
        isOptional,
        scheduledMinuteOfDay,
        updatedAt: now,
        deletedAt: null,
      },
    });

    return this.mapRow(row);
  }

  private mapRow(row: {
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
}

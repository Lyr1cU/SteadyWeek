import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import type { SetDayItemStatusDto } from './day-state.dto';

@Injectable()
export class DayStateService {
  constructor(private readonly prisma: PrismaService) {}

  async listForDay(userId: string, dayKey: string) {
    const rows = await this.prisma.dayItemStatus.findMany({
      where: { userId, dayKey },
      orderBy: { updatedAt: 'asc' },
    });
    return rows.map((row) => ({
      dayKey: row.dayKey,
      routineItemId: row.routineItemId,
      status: row.status,
      updatedAt: row.updatedAt.toISOString(),
    }));
  }

  async setStatus(userId: string, dto: SetDayItemStatusDto) {
    const routine = await this.prisma.routineItem.findUnique({
      where: { id: dto.routineItemId },
    });
    if (!routine || routine.userId !== userId || routine.deletedAt != null) {
      throw new BadRequestException('Routine item not found');
    }

    const now = new Date();
    const row = await this.prisma.dayItemStatus.upsert({
      where: {
        userId_dayKey_routineItemId: {
          userId,
          dayKey: dto.dayKey,
          routineItemId: dto.routineItemId,
        },
      },
      create: {
        userId,
        dayKey: dto.dayKey,
        routineItemId: dto.routineItemId,
        status: dto.status,
        updatedAt: now,
      },
      update: {
        status: dto.status,
        updatedAt: now,
      },
    });

    return {
      dayKey: row.dayKey,
      routineItemId: row.routineItemId,
      status: row.status,
      updatedAt: row.updatedAt.toISOString(),
    };
  }
}

import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RoutineService {
  constructor(private readonly prisma: PrismaService) {}

  async list(userId: string) {
    const rows = await this.prisma.routineItem.findMany({
      where: { userId, deletedAt: null },
      orderBy: [{ sortOrder: 'asc' }, { title: 'asc' }],
    });
    return rows.map((row) => ({
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
    }));
  }
}

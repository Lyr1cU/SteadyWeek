import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

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
}

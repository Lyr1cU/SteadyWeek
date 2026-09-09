import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { pickAssistantTemplate, type TodayItemContext } from './assistant-templates';
import type { AssistantChatDto, AssistantChatResponse } from './assistant.dto';
import { completeGroqChat } from './groq-client';
import { AssistantRateLimiter } from './rate-limit';
import { parseDayKey, routineRunsOnDate } from './weekdays';

@Injectable()
export class AssistantService {
  private readonly rateLimiter = new AssistantRateLimiter();

  constructor(private readonly prisma: PrismaService) {}

  async chat(userId: string, dto: AssistantChatDto): Promise<AssistantChatResponse> {
    if (!this.rateLimiter.assert(userId)) {
      throw new HttpException('Assistant rate limit exceeded', HttpStatus.TOO_MANY_REQUESTS);
    }

    const dayKey = dto.dayKey;
    const items = await this.loadTodayContext(userId, dayKey);
    const trimmed = dto.message.trim();

    if (!trimmed) {
      return {
        reply: pickAssistantTemplate('what is on today', items),
        source: 'template',
      };
    }

    const apiKey = process.env.GROQ_API_KEY?.trim();
    if (!apiKey) {
      return {
        reply: pickAssistantTemplate(trimmed, items),
        source: 'template',
      };
    }

    try {
      const reply = await completeGroqChat(apiKey, trimmed, dayKey, items);
      return { reply, source: 'groq' };
    } catch {
      return {
        reply: pickAssistantTemplate(trimmed, items),
        source: 'template',
      };
    }
  }

  private async loadTodayContext(userId: string, dayKey: string): Promise<TodayItemContext[]> {
    const date = parseDayKey(dayKey);
    const [routines, statuses] = await Promise.all([
      this.prisma.routineItem.findMany({
        where: { userId, deletedAt: null },
        orderBy: [{ sortOrder: 'asc' }, { title: 'asc' }],
      }),
      this.prisma.dayItemStatus.findMany({
        where: { userId, dayKey },
      }),
    ]);

    const statusByItemId = new Map(statuses.map((row) => [row.routineItemId, row.status]));
    return routines
      .filter((row) => routineRunsOnDate(row.weekdays, date))
      .map((row) => ({
        title: row.title,
        sphere: row.sphere,
        effort: row.effort,
        status: statusByItemId.get(row.id) ?? 'pending',
        isOptional: row.isOptional,
      }));
  }
}

import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { ScheduleDayQueryDto, ScheduleWeekQueryDto } from './schedule.dto';
import { ScheduleService } from './schedule.service';

@Controller('schedule')
@UseGuards(AuthGuard('jwt'))
export class ScheduleController {
  constructor(private readonly schedule: ScheduleService) {}

  /** Calendar today in server local timezone — MCP clients may pass explicit dayKey instead. */
  @Get('today')
  getToday(@CurrentUser() user: AuthUser) {
    return this.schedule.getDay(user.userId, this.schedule.todayKeyLocal());
  }

  @Get('day')
  getDay(@CurrentUser() user: AuthUser, @Query() query: ScheduleDayQueryDto) {
    return this.schedule.getDay(user.userId, query.dayKey);
  }

  @Get('week')
  getWeek(@CurrentUser() user: AuthUser, @Query() query: ScheduleWeekQueryDto) {
    return this.schedule.getWeek(user.userId, query.startDayKey);
  }
}

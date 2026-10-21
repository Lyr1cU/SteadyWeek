import { Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { UpsertWeeklyGoalDto, WeeklyGoalsQueryDto } from './weekly-goals.dto';
import { WeeklyGoalsService } from './weekly-goals.service';

@Controller('weekly-goals')
@UseGuards(AuthGuard('jwt'))
export class WeeklyGoalsController {
  constructor(private readonly goals: WeeklyGoalsService) {}

  @Get()
  list(@CurrentUser() user: AuthUser, @Query() query: WeeklyGoalsQueryDto) {
    return this.goals.listForWeek(user.userId, query.weekKey);
  }

  @Post('upsert')
  upsert(@CurrentUser() user: AuthUser, @Body() dto: UpsertWeeklyGoalDto) {
    return this.goals.upsert(user.userId, dto);
  }
}

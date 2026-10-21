import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { DailyReportQueryDto, WeeklyReportQueryDto } from './insights.dto';
import { InsightsService } from './insights.service';

@Controller('insights')
@UseGuards(AuthGuard('jwt'))
export class InsightsController {
  constructor(private readonly insights: InsightsService) {}

  @Get('user-stats')
  getUserStats(@CurrentUser() user: AuthUser) {
    return this.insights.getUserStats(user.userId);
  }

  @Get('daily-report')
  getDailyReport(@CurrentUser() user: AuthUser, @Query() query: DailyReportQueryDto) {
    return this.insights.getDailyReport(user.userId, query.dayKey);
  }

  @Get('weekly-report')
  getWeeklyReport(@CurrentUser() user: AuthUser, @Query() query: WeeklyReportQueryDto) {
    return this.insights.getWeeklyReport(user.userId, query.weekKey);
  }
}

import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { SetDayItemStatusDto } from './day-state.dto';
import { DayStateService } from './day-state.service';

@Controller('day-state')
@UseGuards(AuthGuard('jwt'))
export class DayStateController {
  constructor(private readonly dayState: DayStateService) {}

  @Get()
  listForDay(@CurrentUser() user: AuthUser, @Query('dayKey') dayKey: string) {
    return this.dayState.listForDay(user.userId, dayKey);
  }

  @Post('status')
  setStatus(@CurrentUser() user: AuthUser, @Body() dto: SetDayItemStatusDto) {
    return this.dayState.setStatus(user.userId, dto);
  }
}

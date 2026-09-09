import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { DayStateService } from './day-state.service';

@Controller('day-state')
@UseGuards(AuthGuard('jwt'))
export class DayStateController {
  constructor(private readonly dayState: DayStateService) {}

  @Get()
  listForDay(@CurrentUser() user: AuthUser, @Query('dayKey') dayKey: string) {
    return this.dayState.listForDay(user.userId, dayKey);
  }
}

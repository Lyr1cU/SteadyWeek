import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { UpsertRoutineItemDto } from './routine.dto';
import { RoutineService } from './routine.service';

@Controller('routine')
@UseGuards(AuthGuard('jwt'))
export class RoutineController {
  constructor(private readonly routine: RoutineService) {}

  @Get()
  list(@CurrentUser() user: AuthUser) {
    return this.routine.list(user.userId);
  }

  @Post('upsert')
  upsert(@CurrentUser() user: AuthUser, @Body() dto: UpsertRoutineItemDto) {
    return this.routine.upsert(user.userId, dto);
  }
}

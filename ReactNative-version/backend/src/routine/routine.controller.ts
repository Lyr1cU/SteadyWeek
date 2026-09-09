import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { RoutineService } from './routine.service';

@Controller('routine')
@UseGuards(AuthGuard('jwt'))
export class RoutineController {
  constructor(private readonly routine: RoutineService) {}

  @Get()
  list(@CurrentUser() user: AuthUser) {
    return this.routine.list(user.userId);
  }
}

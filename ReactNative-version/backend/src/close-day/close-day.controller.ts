import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { CloseDayDto } from './close-day.dto';
import { CloseDayService } from './close-day.service';

@Controller('close-day')
@UseGuards(AuthGuard('jwt'))
export class CloseDayController {
  constructor(private readonly closeDay: CloseDayService) {}

  @Post()
  submit(@CurrentUser() user: AuthUser, @Body() dto: CloseDayDto) {
    return this.closeDay.close(user.userId, dto);
  }
}

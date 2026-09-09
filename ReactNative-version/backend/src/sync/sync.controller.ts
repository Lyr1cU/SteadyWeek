import { BadRequestException, Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { SyncPushDto } from './sync.dto';
import { SyncService } from './sync.service';

@Controller('sync')
@UseGuards(AuthGuard('jwt'))
export class SyncController {
  constructor(private readonly sync: SyncService) {}

  @Get('pull')
  pull(@CurrentUser() user: AuthUser, @Query('since') since?: string) {
    const sinceDate = since ? new Date(since) : new Date(0);
    if (Number.isNaN(sinceDate.getTime())) {
      throw new BadRequestException('Invalid since timestamp');
    }
    return this.sync.pull(user.userId, sinceDate);
  }

  @Post('push')
  push(@CurrentUser() user: AuthUser, @Body() dto: SyncPushDto) {
    return this.sync.push(user.userId, dto);
  }
}

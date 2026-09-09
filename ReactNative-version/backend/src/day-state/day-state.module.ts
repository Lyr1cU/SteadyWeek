import { Module } from '@nestjs/common';
import { DayStateController } from './day-state.controller';
import { DayStateService } from './day-state.service';

@Module({
  controllers: [DayStateController],
  providers: [DayStateService],
})
export class DayStateModule {}

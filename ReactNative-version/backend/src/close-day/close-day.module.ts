import { Module } from '@nestjs/common';
import { ScheduleModule } from '../schedule/schedule.module';
import { WeeklyGoalsModule } from '../weekly-goals/weekly-goals.module';
import { CloseDayController } from './close-day.controller';
import { CloseDayService } from './close-day.service';

@Module({
  imports: [ScheduleModule, WeeklyGoalsModule],
  controllers: [CloseDayController],
  providers: [CloseDayService],
})
export class CloseDayModule {}

import { Module } from '@nestjs/common';
import { AssistantModule } from './assistant/assistant.module';
import { AuthModule } from './auth/auth.module';
import { DayStateModule } from './day-state/day-state.module';
import { HealthController } from './health.controller';
import { PrismaModule } from './prisma/prisma.module';
import { RoutineModule } from './routine/routine.module';
import { ScheduleModule } from './schedule/schedule.module';
import { SyncModule } from './sync/sync.module';
import { WeeklyGoalsModule } from './weekly-goals/weekly-goals.module';
import { InsightsModule } from './insights/insights.module';
import { CloseDayModule } from './close-day/close-day.module';

@Module({
  imports: [
    PrismaModule,
    AuthModule,
    RoutineModule,
    DayStateModule,
    SyncModule,
    ScheduleModule,
    AssistantModule,
    WeeklyGoalsModule,
    InsightsModule,
    CloseDayModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}

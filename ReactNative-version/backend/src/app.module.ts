import { Module } from '@nestjs/common';
import { AssistantModule } from './assistant/assistant.module';
import { AuthModule } from './auth/auth.module';
import { DayStateModule } from './day-state/day-state.module';
import { HealthController } from './health.controller';
import { PrismaModule } from './prisma/prisma.module';
import { RoutineModule } from './routine/routine.module';
import { SyncModule } from './sync/sync.module';

@Module({
  imports: [PrismaModule, AuthModule, RoutineModule, DayStateModule, SyncModule, AssistantModule],
  controllers: [HealthController],
})
export class AppModule {}

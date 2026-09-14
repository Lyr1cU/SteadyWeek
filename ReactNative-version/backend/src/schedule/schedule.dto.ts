import { IsOptional, IsString, Matches } from 'class-validator';

export class ScheduleDayQueryDto {
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  dayKey!: string;
}

export class ScheduleWeekQueryDto {
  @IsOptional()
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  startDayKey?: string;
}

export type ScheduleDayItem = {
  id: string;
  title: string;
  sphere: string;
  effort: string;
  status: string;
  isOptional: boolean;
  scheduledMinuteOfDay: number | null;
};

export type ScheduleDayResponse = {
  dayKey: string;
  items: ScheduleDayItem[];
};

export type ScheduleWeekResponse = {
  weekStart: string;
  days: ScheduleDayResponse[];
};

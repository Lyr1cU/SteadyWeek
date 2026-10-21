import { IsOptional, IsString, Matches } from 'class-validator';

export class DailyReportQueryDto {
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  dayKey!: string;
}

export class WeeklyReportQueryDto {
  @IsOptional()
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  weekKey?: string;
}

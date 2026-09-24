import { Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsISO8601,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { EFFORTS, LIFE_SPHERES } from '../common/routine-fields';
import { DAY_TIERS, GOAL_STATUSES } from '../common/goal-fields';

export class RoutineItemDto {
  @IsString()
  id!: string;

  @IsString()
  @MinLength(1)
  @MaxLength(120)
  title!: string;

  @IsIn([...LIFE_SPHERES])
  sphere!: string;

  @IsInt()
  weekdays!: number;

  @IsInt()
  sortOrder!: number;

  @IsIn([...EFFORTS])
  effort!: string;

  @IsBoolean()
  isOptional!: boolean;

  @IsOptional()
  @IsInt()
  scheduledMinuteOfDay!: number | null;

  @IsISO8601()
  createdAt!: string;

  @IsISO8601()
  updatedAt!: string;

  @IsOptional()
  @IsISO8601()
  deletedAt!: string | null;
}

export class DayItemStatusDto {
  @IsString()
  dayKey!: string;

  @IsString()
  routineItemId!: string;

  @IsString()
  status!: string;

  @IsISO8601()
  updatedAt!: string;
}

export class AppSettingDto {
  @IsString()
  key!: string;

  @IsString()
  value!: string;

  @IsISO8601()
  updatedAt!: string;
}

export class UserStatsDto {
  @IsInt()
  @Min(0)
  totalXp!: number;

  @IsInt()
  @Min(0)
  currentStreak!: number;

  @IsInt()
  @Min(0)
  bestStreak!: number;

  @IsOptional()
  @IsString()
  lastGreenDayKey!: string | null;

  @IsISO8601()
  updatedAt!: string;
}

export class WeeklyGoalDto {
  @IsString()
  id!: string;

  @IsString()
  weekKey!: string;

  @IsIn([...LIFE_SPHERES])
  sphere!: string;

  @IsString()
  @MinLength(1)
  @MaxLength(120)
  title!: string;

  @IsInt()
  @Min(1)
  targetCount!: number;

  @IsInt()
  @Min(0)
  progressCount!: number;

  @IsIn([...GOAL_STATUSES])
  status!: string;

  @IsISO8601()
  updatedAt!: string;

  @IsOptional()
  @IsISO8601()
  deletedAt!: string | null;
}

export class DailyReportDto {
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  dayKey!: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(5)
  mood!: number | null;

  @IsString()
  @MaxLength(2000)
  noteHighlight!: string;

  @IsString()
  @MaxLength(4000)
  noteReflection!: string;

  @IsIn([...DAY_TIERS])
  dayTier!: string;

  @IsInt()
  @Min(0)
  @Max(500)
  xpAwarded!: number;

  @IsOptional()
  @IsBoolean()
  workImbalance?: boolean;

  @IsISO8601()
  closedAt!: string;

  @IsISO8601()
  updatedAt!: string;
}

export class WeeklyReportDto {
  @IsString()
  weekKey!: string;

  @IsString()
  @MaxLength(4000)
  noteWin!: string;

  @IsString()
  @MaxLength(4000)
  noteFocus!: string;

  @IsISO8601()
  updatedAt!: string;
}

export class SyncPushDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => RoutineItemDto)
  routineItems!: RoutineItemDto[];

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => DayItemStatusDto)
  dayItemStatus!: DayItemStatusDto[];

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => AppSettingDto)
  appSettings!: AppSettingDto[];

  @IsOptional()
  @ValidateNested()
  @Type(() => UserStatsDto)
  userStats!: UserStatsDto | null;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WeeklyGoalDto)
  weeklyGoals?: WeeklyGoalDto[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => DailyReportDto)
  dailyReports?: DailyReportDto[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WeeklyReportDto)
  weeklyReports?: WeeklyReportDto[];
}

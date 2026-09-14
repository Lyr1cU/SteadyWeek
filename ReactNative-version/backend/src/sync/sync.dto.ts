import { Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsISO8601,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { EFFORTS, LIFE_SPHERES } from '../common/routine-fields';

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
}

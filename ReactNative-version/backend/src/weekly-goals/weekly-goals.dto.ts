import {
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateIf,
} from 'class-validator';
import { GOAL_STATUSES } from '../common/goal-fields';
import { LIFE_SPHERES } from '../common/routine-fields';

export class WeeklyGoalsQueryDto {
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  weekKey!: string;
}

export class UpsertWeeklyGoalDto {
  @ValidateIf((dto: UpsertWeeklyGoalDto) => Boolean(dto.delete) || dto.id != null)
  @IsString()
  @MinLength(1)
  @MaxLength(64)
  id?: string;

  @ValidateIf((dto: UpsertWeeklyGoalDto) => !dto.delete)
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  weekKey?: string;

  @ValidateIf((dto: UpsertWeeklyGoalDto) => !dto.delete)
  @IsString()
  @MinLength(1)
  @MaxLength(120)
  title?: string;

  @ValidateIf((dto: UpsertWeeklyGoalDto) => !dto.delete)
  @IsIn([...LIFE_SPHERES])
  sphere?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(99)
  targetCount?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(99)
  progressCount?: number;

  @IsOptional()
  @IsIn([...GOAL_STATUSES])
  status?: string;

  @IsOptional()
  @IsBoolean()
  delete?: boolean;
}

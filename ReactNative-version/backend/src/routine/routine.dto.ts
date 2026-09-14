import {
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateIf,
} from 'class-validator';
import { EFFORTS, LIFE_SPHERES } from '../common/routine-fields';

export class UpsertRoutineItemDto {
  @ValidateIf((dto: UpsertRoutineItemDto) => Boolean(dto.delete) || dto.id != null)
  @IsString()
  @MinLength(1)
  @MaxLength(64)
  id?: string;

  @ValidateIf((dto: UpsertRoutineItemDto) => !dto.delete)
  @IsString()
  @MinLength(1)
  @MaxLength(120)
  title?: string;

  @ValidateIf((dto: UpsertRoutineItemDto) => !dto.delete)
  @IsIn([...LIFE_SPHERES])
  sphere?: string;

  @ValidateIf((dto: UpsertRoutineItemDto) => !dto.delete)
  @IsInt()
  @Min(0)
  @Max(127)
  weekdays?: number;

  @IsOptional()
  @IsInt()
  sortOrder?: number;

  @IsOptional()
  @IsIn([...EFFORTS])
  effort?: string;

  @IsOptional()
  @IsBoolean()
  isOptional?: boolean;

  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(1439)
  scheduledMinuteOfDay?: number | null;

  @IsOptional()
  @IsBoolean()
  delete?: boolean;
}

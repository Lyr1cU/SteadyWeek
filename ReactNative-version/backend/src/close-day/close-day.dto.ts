import {
  IsInt,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

export class CloseDayDto {
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  dayKey!: string;

  @IsString()
  @MaxLength(2000)
  noteHighlight!: string;

  @IsString()
  @MaxLength(4000)
  noteReflection!: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(5)
  mood?: number | null;
}

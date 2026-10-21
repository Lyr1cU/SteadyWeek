import { IsIn, IsString, Matches } from 'class-validator';
import { DAY_ITEM_STATUSES } from '../common/day-status-fields';

export class SetDayItemStatusDto {
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  dayKey!: string;

  @IsString()
  routineItemId!: string;

  @IsIn([...DAY_ITEM_STATUSES])
  status!: string;
}

import { IsString, Matches, MaxLength, MinLength } from 'class-validator';

export class AssistantChatDto {
  @IsString()
  @MinLength(1)
  @MaxLength(500)
  message!: string;

  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  dayKey!: string;
}

export type AssistantChatResponse = {
  reply: string;
  source: 'groq' | 'template';
};

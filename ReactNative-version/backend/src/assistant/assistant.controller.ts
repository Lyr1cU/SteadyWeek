import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CurrentUser, type AuthUser } from '../auth/current-user.decorator';
import { AssistantChatDto } from './assistant.dto';
import { AssistantService } from './assistant.service';

@Controller('assistant')
@UseGuards(AuthGuard('jwt'))
export class AssistantController {
  constructor(private readonly assistant: AssistantService) {}

  @Post('chat')
  chat(@CurrentUser() user: AuthUser, @Body() dto: AssistantChatDto) {
    return this.assistant.chat(user.userId, dto);
  }
}

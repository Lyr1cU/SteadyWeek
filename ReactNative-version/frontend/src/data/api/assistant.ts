import { apiFetch } from './client';

export type AssistantChatResponse = {
  reply: string;
  source: 'groq' | 'template';
};

export async function chatAssistant(
  message: string,
  dayKey: string,
): Promise<AssistantChatResponse> {
  return apiFetch<AssistantChatResponse>('/assistant/chat', {
    method: 'POST',
    body: JSON.stringify({ message, dayKey }),
  });
}

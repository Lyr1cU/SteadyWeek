import NetInfo from '@react-native-community/netinfo';
import { useCallback, useState } from 'react';
import { useSync } from '../../app/sync-context';
import { useRepos } from '../../app/repos-context';
import { chatAssistant } from '../../data/api/assistant';
import { isLoggedIn } from '../../data/auth/auth-store';
import { dateKey, startOfLocalDay } from '../../logic/calendar';
import { pickAssistantTemplate, todayRowsToContext } from '../../logic/assistant-templates';

export type ChatMessage = {
  id: string;
  role: 'user' | 'assistant';
  text: string;
  source?: 'groq' | 'template';
};

function newId(): string {
  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
}

export function useAssistantChat() {
  const { routine } = useRepos();
  const { loggedIn } = useSync();
  const [input, setInput] = useState('');
  const [busy, setBusy] = useState(false);
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      id: newId(),
      role: 'assistant',
      text: 'Hi — ask about today’s routine. Offline or busy? I still answer from templates.',
      source: 'template',
    },
  ]);

  const respond = useCallback(
    async (question: string) => {
      const trimmed = question.trim();
      if (!trimmed || busy) {
        return;
      }

      setMessages((prev) => [...prev, { id: newId(), role: 'user', text: trimmed }]);
      setInput('');
      setBusy(true);

      try {
        const today = startOfLocalDay(new Date());
        const dayKey = dateKey(today);
        const rows = await routine.loadTodayRows(today);
        const context = todayRowsToContext(rows);

        const online = (await NetInfo.fetch()).isConnected === true;
        const authed = loggedIn && (await isLoggedIn());

        if (online && authed) {
          try {
            const result = await chatAssistant(trimmed, dayKey);
            setMessages((prev) => [
              ...prev,
              {
                id: newId(),
                role: 'assistant',
                text: result.reply,
                source: result.source,
              },
            ]);
            return;
          } catch {
            // Groq unavailable, rate limited, or auth issue — template fallback.
          }
        }

        setMessages((prev) => [
          ...prev,
          {
            id: newId(),
            role: 'assistant',
            text: pickAssistantTemplate(trimmed, context),
            source: 'template',
          },
        ]);
      } finally {
        setBusy(false);
      }
    },
    [busy, loggedIn, routine],
  );

  return { input, setInput, busy, messages, loggedIn, respond };
}

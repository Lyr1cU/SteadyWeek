import NetInfo from '@react-native-community/netinfo';
import { useCallback, useState } from 'react';
import { useSync } from '../../app/sync-context';
import { useRepos } from '../../app/repos-context';
import { chatAssistant } from '../../data/api/assistant';
import { ApiError } from '../../data/api/client';
import { isLoggedIn } from '../../data/auth/auth-store';
import { dateKey, localDayFromKey, startOfLocalDay } from '../../logic/calendar';
import { pickAssistantTemplate, todayRowsToContext } from '../../logic/assistant-templates';
import { strings } from '../../l10n';

export type ChatMessage = {
  id: string;
  role: 'user' | 'assistant';
  text: string;
  source?: 'groq' | 'template';
};

function newId(): string {
  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
}

export function useAssistantChat(contextDayKey?: string) {
  const { routine } = useRepos();
  const { loggedIn } = useSync();
  const [input, setInput] = useState('');
  const [busy, setBusy] = useState(false);
  const copy = strings().assistant;
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      id: newId(),
      role: 'assistant',
      text: copy.greeting,
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
        const dayKey =
          contextDayKey && /^\d{4}-\d{2}-\d{2}$/.test(contextDayKey)
            ? contextDayKey
            : dateKey(startOfLocalDay(new Date()));
        const dayDate = localDayFromKey(dayKey);
        const rows = await routine.loadTodayRows(dayDate);
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
          } catch (error) {
            const hint =
              error instanceof ApiError
                ? error.message
                : error instanceof Error
                  ? error.message
                  : 'Request failed';
            setMessages((prev) => [
              ...prev,
              {
                id: newId(),
                role: 'assistant',
                text: `${pickAssistantTemplate(trimmed, context)}\n\n(${hint})`,
                source: 'template',
              },
            ]);
            return;
          }
        }

        if (!authed) {
          setMessages((prev) => [
            ...prev,
            {
              id: newId(),
              role: 'assistant',
              text: `${pickAssistantTemplate(trimmed, context)}\n\n(Sign in on Profile for Groq.)`,
              source: 'template',
            },
          ]);
          return;
        }

        if (!online) {
          setMessages((prev) => [
            ...prev,
            {
              id: newId(),
              role: 'assistant',
              text: pickAssistantTemplate(trimmed, context),
              source: 'template',
            },
          ]);
          return;
        }
      } finally {
        setBusy(false);
      }
    },
    [busy, contextDayKey, loggedIn, routine],
  );

  const activeDayKey =
    contextDayKey && /^\d{4}-\d{2}-\d{2}$/.test(contextDayKey)
      ? contextDayKey
      : dateKey(startOfLocalDay(new Date()));

  return { input, setInput, busy, messages, loggedIn, respond, contextDayKey: activeDayKey };
}

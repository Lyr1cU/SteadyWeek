import { useCallback, useEffect, useRef } from 'react';
import { Ionicons } from '@expo/vector-icons';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { localDayFromKey } from '../../logic/calendar';
import { ASSISTANT_QUICK_PROMPTS } from '../../logic/assistant-templates';
import { strings } from '../../l10n';
import { AppBackground } from '../../ui/app-background';
import { theme } from '../../ui/theme';
import { useKeyboardBottomInset } from '../../ui/use-keyboard-inset';
import { AssistantComposer } from './assistant-composer';
import { AssistantMessageBubble, AssistantTypingBubble } from './assistant-message-bubble';
import { AssistantQuickPrompts } from './assistant-quick-prompts';
import { useAssistantChat } from './use-assistant-chat';

function formatDayLabel(dayKey: string): string {
  const d = localDayFromKey(dayKey);
  return d.toLocaleDateString(undefined, {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

export function AssistantScreen({
  onBack,
  contextDayKey,
}: {
  onBack: () => void;
  contextDayKey?: string;
}) {
  const { input, setInput, busy, messages, loggedIn, respond, contextDayKey: dayKey } =
    useAssistantChat(contextDayKey);
  const copy = strings();
  const keyboardInset = useKeyboardBottomInset();
  const scrollRef = useRef<ScrollView>(null);

  const scrollToEnd = useCallback(() => {
    requestAnimationFrame(() => {
      scrollRef.current?.scrollToEnd({ animated: true });
    });
  }, []);

  useEffect(() => {
    scrollToEnd();
  }, [messages, busy, scrollToEnd]);

  const showQuickHint = messages.length === 1 && messages[0]?.role === 'assistant';

  return (
    <AppBackground>
      <View style={styles.root}>
        <View style={styles.header}>
          <Pressable onPress={onBack} style={({ pressed }) => [styles.back, pressed && styles.pressed]}>
            <Ionicons name="chevron-back" size={22} color={theme.colors.accent} />
            <Text style={styles.backText}>{copy.common.back}</Text>
          </Pressable>
          <Text style={styles.title}>{copy.assistant.title}</Text>
          <Text style={styles.dayLine}>{copy.assistant.dayContext(formatDayLabel(dayKey))}</Text>
          <View style={styles.statusPill}>
            <Text style={styles.statusText}>
              {loggedIn ? copy.assistant.statusGroq : copy.assistant.statusTemplates}
            </Text>
          </View>
          <Text style={styles.subtitle}>
            {loggedIn ? copy.assistant.groqHint : copy.assistant.templateHint}
          </Text>
        </View>

        <ScrollView
          ref={scrollRef}
          style={styles.messages}
          contentContainerStyle={styles.messagesContent}
          keyboardShouldPersistTaps="handled"
          onContentSizeChange={scrollToEnd}
        >
          {messages.map((msg) => (
            <AssistantMessageBubble key={msg.id} msg={msg} />
          ))}
          {busy ? <AssistantTypingBubble /> : null}
          {showQuickHint && !busy ? (
            <Text style={styles.quickHint}>{copy.assistant.tryQuickPrompts}</Text>
          ) : null}
        </ScrollView>

        <AssistantQuickPrompts
          prompts={ASSISTANT_QUICK_PROMPTS}
          busy={busy}
          onPrompt={(p) => void respond(p)}
        />

        <AssistantComposer
          input={input}
          busy={busy}
          bottomInset={keyboardInset}
          onChange={setInput}
          onSend={() => void respond(input)}
        />
      </View>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  header: {
    paddingHorizontal: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 10,
  },
  back: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 2,
    marginBottom: 8,
    alignSelf: 'flex-start',
  },
  backText: { color: theme.colors.accent, fontWeight: '600', fontSize: 16 },
  pressed: { opacity: 0.88 },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  dayLine: { marginTop: 4, fontSize: 15, fontWeight: '600', color: theme.colors.text },
  statusPill: {
    marginTop: 8,
    alignSelf: 'flex-start',
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(202, 184, 255, 0.1)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(202, 184, 255, 0.28)',
  },
  statusText: { fontSize: 12, fontWeight: '600', color: theme.colors.accentMuted },
  subtitle: { marginTop: 8, color: theme.colors.textMuted, lineHeight: 20, fontSize: 13 },
  messages: { flex: 1 },
  messagesContent: {
    paddingHorizontal: theme.spacing.screenX,
    paddingTop: 4,
    paddingBottom: 8,
    gap: 10,
  },
  quickHint: {
    alignSelf: 'center',
    marginTop: 8,
    color: theme.colors.textSubtle,
    fontSize: 13,
    fontStyle: 'italic',
  },
});

import {
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { ASSISTANT_QUICK_PROMPTS } from '../../logic/assistant-templates';
import { AppBackground } from '../../ui/app-background';
import { theme } from '../../ui/theme';
import { useAssistantChat } from './use-assistant-chat';

export function AssistantScreen({ onBack }: { onBack: () => void }) {
  const { input, setInput, busy, messages, loggedIn, respond } = useAssistantChat();

  return (
    <AppBackground>
      <KeyboardAvoidingView
        style={styles.root}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        keyboardVerticalOffset={Platform.OS === 'ios' ? 8 : 0}
      >
        <View style={styles.header}>
          <Pressable onPress={onBack} style={styles.backBtn}>
            <Text style={styles.backText}>Back</Text>
          </Pressable>
          <Text style={styles.title}>Assistant</Text>
          <Text style={styles.subtitle}>
            {loggedIn
              ? 'Groq when online · templates as fallback'
              : 'Templates from your local today list · sign in for Groq'}
          </Text>
        </View>

        <ScrollView style={styles.messages} contentContainerStyle={styles.messagesContent}>
          {messages.map((msg) => (
            <View
              key={msg.id}
              style={[
                styles.bubble,
                msg.role === 'user' ? styles.userBubble : styles.assistantBubble,
              ]}
            >
              <Text style={[styles.bubbleText, msg.role === 'user' && styles.userBubbleText]}>
                {msg.text}
              </Text>
              {msg.role === 'assistant' && msg.source ? (
                <Text style={styles.sourceTag}>{msg.source === 'groq' ? 'Groq' : 'Template'}</Text>
              ) : null}
            </View>
          ))}
          {busy ? <ActivityIndicator color={theme.colors.accent} style={styles.loader} /> : null}
        </ScrollView>

        <View style={styles.quickRow}>
          {ASSISTANT_QUICK_PROMPTS.map((prompt) => (
            <Pressable
              key={prompt}
              style={styles.quickChip}
              onPress={() => void respond(prompt)}
              disabled={busy}
            >
              <Text style={styles.quickChipText}>{prompt}</Text>
            </Pressable>
          ))}
        </View>

        <View style={styles.composer}>
          <TextInput
            value={input}
            onChangeText={setInput}
            placeholder="Ask about today…"
            placeholderTextColor={theme.colors.textSubtle}
            style={styles.input}
            editable={!busy}
            onSubmitEditing={() => void respond(input)}
          />
          <Pressable
            style={[styles.sendBtn, busy && styles.sendBtnDisabled]}
            disabled={busy || !input.trim()}
            onPress={() => void respond(input)}
          >
            <Text style={styles.sendBtnText}>Send</Text>
          </Pressable>
        </View>
      </KeyboardAvoidingView>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  header: {
    paddingHorizontal: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 12,
  },
  backBtn: { marginBottom: 8 },
  backText: { color: theme.colors.accent, fontWeight: '600', fontSize: 16 },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  subtitle: { marginTop: 6, color: theme.colors.textMuted, lineHeight: 20 },
  messages: { flex: 1 },
  messagesContent: {
    paddingHorizontal: theme.spacing.screenX,
    paddingBottom: 12,
    gap: 10,
  },
  bubble: {
    maxWidth: '88%',
    borderRadius: theme.radius.md,
    paddingHorizontal: 14,
    paddingVertical: 10,
  },
  userBubble: {
    alignSelf: 'flex-end',
    backgroundColor: theme.colors.accent,
  },
  assistantBubble: {
    alignSelf: 'flex-start',
    backgroundColor: theme.colors.surfaceHigh,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  bubbleText: { color: theme.colors.text, lineHeight: 21 },
  userBubbleText: { color: theme.colors.accentOn },
  sourceTag: {
    marginTop: 6,
    fontSize: 11,
    color: theme.colors.textSubtle,
    fontWeight: '600',
  },
  loader: { marginTop: 8 },
  quickRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
    paddingHorizontal: theme.spacing.screenX,
    paddingBottom: 8,
  },
  quickChip: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: theme.colors.surfaceHighest,
  },
  quickChipText: { color: theme.colors.textMuted, fontWeight: '600', fontSize: 12 },
  composer: {
    flexDirection: 'row',
    gap: 8,
    paddingHorizontal: theme.spacing.screenX,
    paddingBottom: 24,
    paddingTop: 8,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: theme.colors.border,
    backgroundColor: theme.colors.chromeSurface,
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: theme.radius.sm,
    paddingHorizontal: 12,
    paddingVertical: 10,
    color: theme.colors.text,
    backgroundColor: theme.colors.surfaceHigh,
  },
  sendBtn: {
    justifyContent: 'center',
    paddingHorizontal: 16,
    borderRadius: theme.radius.sm,
    backgroundColor: theme.colors.accent,
  },
  sendBtnDisabled: { opacity: 0.5 },
  sendBtnText: { color: theme.colors.accentOn, fontWeight: '700' },
});

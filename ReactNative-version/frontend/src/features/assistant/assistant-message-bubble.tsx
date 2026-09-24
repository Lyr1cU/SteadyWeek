import { StyleSheet, Text, View } from 'react-native';
import type { ChatMessage } from './use-assistant-chat';
import { strings } from '../../l10n';
import { FadeInUpView } from '../../ui/motion/enter';
import { PulseText } from '../../ui/motion/pulse-text';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function AssistantMessageBubble({ msg }: { msg: ChatMessage }) {
  const copy = strings().assistant;
  const isUser = msg.role === 'user';

  if (isUser) {
    return (
      <FadeInUpView style={[styles.wrap, styles.userWrap]}>
        <View style={styles.userBubble}>
          <Text style={styles.userText}>{msg.text}</Text>
        </View>
      </FadeInUpView>
    );
  }

  return (
    <FadeInUpView style={[styles.wrap, styles.assistantWrap]}>
      <GlassSurface style={styles.glassBubble}>
        <Text style={styles.assistantText}>{msg.text}</Text>
        {msg.source ? (
          <View style={styles.sourceChip}>
            <Text style={styles.sourceText}>
              {msg.source === 'groq' ? copy.sourceGroq : copy.sourceTemplate}
            </Text>
          </View>
        ) : null}
      </GlassSurface>
    </FadeInUpView>
  );
}

export function AssistantTypingBubble() {
  const copy = strings().assistant;

  return (
    <View style={[styles.wrap, styles.assistantWrap]}>
      <GlassSurface style={styles.typingBubble}>
        <PulseText style={styles.typingText}>{copy.typing}</PulseText>
      </GlassSurface>
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { maxWidth: '88%' },
  userWrap: { alignSelf: 'flex-end' },
  assistantWrap: { alignSelf: 'flex-start' },
  userBubble: {
    borderRadius: theme.radius.lg,
    paddingHorizontal: 14,
    paddingVertical: 10,
    backgroundColor: theme.colors.accent,
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.35)',
  },
  userText: { color: theme.colors.accentOn, lineHeight: 21 },
  glassBubble: {
    borderRadius: theme.radius.lg,
    paddingHorizontal: 14,
    paddingVertical: 10,
  },
  assistantText: { color: theme.colors.text, lineHeight: 21 },
  sourceChip: {
    marginTop: 8,
    alignSelf: 'flex-start',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(202, 184, 255, 0.1)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(202, 184, 255, 0.22)',
  },
  sourceText: { fontSize: 11, fontWeight: '600', color: theme.colors.textSubtle },
  typingBubble: {
    borderRadius: theme.radius.lg,
    paddingHorizontal: 16,
    paddingVertical: 12,
    minWidth: 48,
  },
  typingText: {
    color: theme.colors.textMuted,
    fontSize: 22,
    fontWeight: '700',
    letterSpacing: 2,
  },
});

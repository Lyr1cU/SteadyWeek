import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, TextInput, View } from 'react-native';
import { strings } from '../../l10n';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function AssistantComposer({
  input,
  busy,
  bottomInset,
  onChange,
  onSend,
}: {
  input: string;
  busy: boolean;
  bottomInset: number;
  onChange: (v: string) => void;
  onSend: () => void;
}) {
  const copy = strings();
  const canSend = !busy && input.trim().length > 0;

  return (
    <GlassSurface
      style={[styles.shell, bottomInset > 0 && { marginBottom: bottomInset }]}
    >
      <View style={styles.row}>
        <TextInput
          value={input}
          onChangeText={onChange}
          placeholder={copy.assistant.placeholder}
          placeholderTextColor={theme.colors.textSubtle}
          style={styles.input}
          editable={!busy}
          onSubmitEditing={onSend}
          multiline
          maxLength={2000}
        />
        <AnimatedPressable
          style={[styles.sendBtn, !canSend && styles.sendBtnDisabled]}
          disabled={!canSend}
          onPress={onSend}
          accessibilityLabel={copy.common.send}
        >
          <Ionicons name="send" size={20} color={theme.colors.accentOn} />
        </AnimatedPressable>
      </View>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  shell: {
    marginHorizontal: theme.spacing.screenX,
    marginBottom: 16,
    borderRadius: theme.radius.lg,
    padding: 10,
  },
  row: { flexDirection: 'row', alignItems: 'flex-end', gap: 8 },
  input: {
    flex: 1,
    maxHeight: 100,
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.2)',
    borderRadius: theme.radius.pill,
    paddingHorizontal: 14,
    paddingVertical: 10,
    color: theme.colors.text,
    backgroundColor: 'rgba(8, 7, 14, 0.35)',
  },
  sendBtn: {
    width: 44,
    height: 44,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: theme.colors.accent,
  },
  sendBtnDisabled: { opacity: 0.45 },
});

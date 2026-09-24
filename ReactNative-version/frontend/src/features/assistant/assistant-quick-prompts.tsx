import { StyleSheet, Text, View } from 'react-native';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { theme } from '../../ui/theme';

export function AssistantQuickPrompts({
  prompts,
  busy,
  onPrompt,
}: {
  prompts: readonly string[];
  busy: boolean;
  onPrompt: (text: string) => void;
}) {
  return (
    <View style={styles.row}>
      {prompts.map((prompt) => (
        <AnimatedPressable
          key={prompt}
          style={[styles.chip, busy && styles.chipDisabled]}
          onPress={() => onPrompt(prompt)}
          disabled={busy}
        >
          <Text style={styles.chipText} numberOfLines={2}>
            {prompt}
          </Text>
        </AnimatedPressable>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
    paddingHorizontal: theme.spacing.screenX,
    paddingBottom: 8,
  },
  chip: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(53, 45, 85, 0.45)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(202, 184, 255, 0.28)',
    maxWidth: '100%',
  },
  chipDisabled: { opacity: 0.5 },
  chipText: { color: theme.colors.textMuted, fontWeight: '600', fontSize: 12 },
});

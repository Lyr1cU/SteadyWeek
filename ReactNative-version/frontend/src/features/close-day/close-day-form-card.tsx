import { Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { theme } from '../../ui/theme';

const MOODS = [1, 2, 3, 4, 5] as const;

export function CloseDayFormCard({
  highlight,
  reflection,
  mood,
  error,
  submitting,
  disabled,
  onHighlight,
  onReflection,
  onMood,
  onSubmit,
}: {
  highlight: string;
  reflection: string;
  mood: number | null;
  error: string | null;
  submitting: boolean;
  disabled: boolean;
  onHighlight: (v: string) => void;
  onReflection: (v: string) => void;
  onMood: (m: number | null) => void;
  onSubmit: () => void;
}) {
  const copy = strings().closeDay;

  return (
    <GlassSurface style={styles.card}>
      <Text style={styles.label}>{copy.labelHighlight}</Text>
      <TextInput
        style={styles.input}
        multiline
        value={highlight}
        onChangeText={onHighlight}
        placeholder={copy.placeholderHighlight}
        placeholderTextColor={theme.colors.textSubtle}
        maxLength={2000}
      />

      <Text style={styles.label}>{copy.labelReflection}</Text>
      <TextInput
        style={[styles.input, styles.inputTall]}
        multiline
        value={reflection}
        onChangeText={onReflection}
        placeholder={copy.placeholderReflection}
        placeholderTextColor={theme.colors.textSubtle}
        maxLength={4000}
      />

      <Text style={styles.label}>{copy.labelMood}</Text>
      <Text style={styles.moodHint}>{copy.moodHint}</Text>
      <View style={styles.moodRow}>
        {MOODS.map((m) => {
          const filled = mood != null && m <= mood;
          return (
            <Pressable
              key={m}
              onPress={() => onMood(mood === m ? null : m)}
              style={[styles.moodChip, filled && styles.moodChipOn]}
            >
              <Text style={[styles.moodText, filled && styles.moodTextOn]}>{m}</Text>
            </Pressable>
          );
        })}
      </View>

      {error ? <Text style={styles.error}>{error}</Text> : null}

      <AnimatedPressable
        style={[styles.cta, (submitting || disabled) && styles.ctaDisabled]}
        onPress={onSubmit}
        disabled={submitting || disabled}
      >
        <Text style={styles.ctaText}>{submitting ? copy.saving : copy.submit}</Text>
      </AnimatedPressable>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: { borderRadius: theme.radius.lg, padding: 16 },
  label: {
    color: theme.colors.textMuted,
    marginBottom: 6,
    marginTop: 4,
    fontWeight: '600',
    fontSize: 13,
  },
  input: {
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.2)',
    borderRadius: theme.radius.md,
    padding: 12,
    minHeight: 72,
    color: theme.colors.text,
    backgroundColor: 'rgba(8, 7, 14, 0.35)',
    textAlignVertical: 'top',
  },
  inputTall: { minHeight: 96 },
  moodHint: { fontSize: 12, color: theme.colors.textSubtle, marginBottom: 10 },
  moodRow: { flexDirection: 'row', justifyContent: 'space-between', gap: 6 },
  moodChip: {
    flex: 1,
    maxWidth: 52,
    aspectRatio: 1,
    borderRadius: 999,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(53, 45, 85, 0.45)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  moodChipOn: {
    backgroundColor: theme.colors.accentContainer,
    borderColor: 'rgba(202, 184, 255, 0.55)',
    borderWidth: 1.5,
  },
  moodText: { color: theme.colors.textMuted, fontWeight: '700', fontSize: 16 },
  moodTextOn: { color: theme.colors.accent },
  error: { color: theme.colors.danger, marginTop: 12 },
  cta: {
    marginTop: 20,
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  ctaDisabled: { opacity: 0.5 },
  ctaText: { color: theme.colors.accentOn, fontWeight: '700', fontSize: 16 },
});

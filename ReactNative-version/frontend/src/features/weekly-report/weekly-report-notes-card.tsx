import { StyleSheet, Text, TextInput } from 'react-native';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { theme } from '../../ui/theme';

export function WeeklyReportNotesCard({
  noteWin,
  noteFocus,
  saving,
  saved,
  onWin,
  onFocus,
  onSave,
  onFocusField,
}: {
  noteWin: string;
  noteFocus: string;
  saving: boolean;
  saved: boolean;
  onWin: (v: string) => void;
  onFocus: (v: string) => void;
  onSave: () => void;
  onFocusField: () => void;
}) {
  const copy = strings().weeklyReport;

  return (
    <GlassSurface style={styles.card}>
      <Text style={styles.label}>{copy.labelWin}</Text>
      <TextInput
        style={styles.input}
        multiline
        value={noteWin}
        onChangeText={onWin}
        onFocus={onFocusField}
        placeholder={copy.placeholderWin}
        placeholderTextColor={theme.colors.textSubtle}
        maxLength={4000}
      />

      <Text style={styles.label}>{copy.labelFocus}</Text>
      <TextInput
        style={[styles.input, styles.inputTall]}
        multiline
        value={noteFocus}
        onChangeText={onFocus}
        onFocus={onFocusField}
        placeholder={copy.placeholderFocus}
        placeholderTextColor={theme.colors.textSubtle}
        maxLength={4000}
      />

      {saved ? <Text style={styles.saved}>{copy.saved}</Text> : null}

      <AnimatedPressable
        style={[styles.cta, saving && styles.ctaDisabled]}
        onPress={onSave}
        disabled={saving}
      >
        <Text style={styles.ctaText}>{saving ? copy.saving : copy.saveNotes}</Text>
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
    minHeight: 80,
    color: theme.colors.text,
    backgroundColor: 'rgba(8, 7, 14, 0.35)',
    textAlignVertical: 'top',
  },
  inputTall: { minHeight: 96 },
  saved: { color: theme.colors.accent, marginTop: 12, fontWeight: '600' },
  cta: {
    marginTop: 20,
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  ctaDisabled: { opacity: 0.7 },
  ctaText: { color: theme.colors.accentOn, fontWeight: '700', fontSize: 16 },
});

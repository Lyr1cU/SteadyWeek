import { Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { LIFE_SPHERES } from '../../domain/life-sphere';
import type { Effort, RoutineItemInput } from '../../domain/models';
import { toggleWeekdayMask, WEEKDAY_LABELS, weekdayMaskFromIndex } from '../../logic/weekdays';
import { theme } from '../../ui/theme';

const EFFORTS: Effort[] = ['light', 'medium', 'heavy'];

export function RoutineForm({
  draft,
  timeText,
  error,
  editing,
  onDraft,
  onTimeText,
  onSave,
  onCancel,
}: {
  draft: RoutineItemInput;
  timeText: string;
  error: string | null;
  editing: boolean;
  onDraft: (next: RoutineItemInput) => void;
  onTimeText: (value: string) => void;
  onSave: () => void;
  onCancel: () => void;
}) {
  return (
    <View style={styles.form}>
      <Text style={styles.formTitle}>{editing ? 'Edit item' : 'Add item'}</Text>

      <Text style={styles.label}>Title</Text>
      <TextInput
        value={draft.title}
        onChangeText={(title) => onDraft({ ...draft, title })}
        placeholder="Deep work block"
        placeholderTextColor={theme.colors.textSubtle}
        style={styles.input}
      />

      <Text style={styles.label}>Weekdays</Text>
      <View style={styles.weekdayRow}>
        {WEEKDAY_LABELS.map((label, index) => {
          const on = (draft.weekdays & weekdayMaskFromIndex(index)) !== 0;
          return (
            <Pressable
              key={label}
              onPress={() => onDraft({ ...draft, weekdays: toggleWeekdayMask(draft.weekdays, index) })}
              style={[styles.weekdayChip, on && styles.weekdayChipOn]}
            >
              <Text style={[styles.weekdayChipText, on && styles.weekdayChipTextOn]}>{label}</Text>
            </Pressable>
          );
        })}
      </View>

      <Text style={styles.label}>Time (optional, HH:MM)</Text>
      <TextInput
        value={timeText}
        onChangeText={onTimeText}
        placeholder="09:00"
        placeholderTextColor={theme.colors.textSubtle}
        style={styles.input}
        keyboardType="numbers-and-punctuation"
      />

      <Text style={styles.label}>Sphere</Text>
      <View style={styles.chipRow}>
        {LIFE_SPHERES.map((sphere) => {
          const on = draft.sphere === sphere;
          return (
            <Pressable
              key={sphere}
              onPress={() => onDraft({ ...draft, sphere })}
              style={[styles.chip, on && styles.chipOn]}
            >
              <Text style={[styles.chipText, on && styles.chipTextOn]}>{sphere}</Text>
            </Pressable>
          );
        })}
      </View>

      <Text style={styles.label}>Effort</Text>
      <View style={styles.chipRow}>
        {EFFORTS.map((effort) => {
          const on = draft.effort === effort;
          return (
            <Pressable
              key={effort}
              onPress={() => onDraft({ ...draft, effort })}
              style={[styles.chip, on && styles.chipOn]}
            >
              <Text style={[styles.chipText, on && styles.chipTextOn]}>{effort}</Text>
            </Pressable>
          );
        })}
      </View>

      <Pressable
        onPress={() => onDraft({ ...draft, isOptional: !draft.isOptional })}
        style={styles.optionalRow}
      >
        <View style={[styles.checkbox, draft.isOptional && styles.checkboxOn]} />
        <Text style={styles.optionalText}>Optional item</Text>
      </Pressable>

      {error ? <Text style={styles.error}>{error}</Text> : null}

      <View style={styles.formActions}>
        <Pressable style={styles.primaryBtn} onPress={onSave}>
          <Text style={styles.primaryBtnText}>{editing ? 'Save changes' : 'Add item'}</Text>
        </Pressable>
        {editing ? (
          <Pressable style={styles.secondaryBtn} onPress={onCancel}>
            <Text style={styles.secondaryBtnText}>Cancel</Text>
          </Pressable>
        ) : null}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  form: {
    backgroundColor: theme.colors.surfaceHigh,
    borderRadius: theme.radius.md,
    padding: 16,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  formTitle: { fontSize: 18, fontWeight: '700', marginBottom: 12, color: theme.colors.text },
  label: {
    marginTop: 10,
    marginBottom: 6,
    color: theme.colors.textMuted,
    fontWeight: '600',
    fontSize: 13,
  },
  input: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: theme.radius.sm,
    paddingHorizontal: 12,
    paddingVertical: 10,
    backgroundColor: theme.colors.surface,
    color: theme.colors.text,
  },
  weekdayRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  weekdayChip: {
    paddingHorizontal: 10,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: theme.colors.surfaceHighest,
  },
  weekdayChipOn: { backgroundColor: theme.colors.accentContainer },
  weekdayChipText: { color: theme.colors.textMuted, fontWeight: '600', fontSize: 12 },
  weekdayChipTextOn: { color: theme.colors.accent },
  chipRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  chip: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: theme.colors.surfaceHighest,
  },
  chipOn: { backgroundColor: theme.colors.accentContainer },
  chipText: { color: theme.colors.textMuted, fontWeight: '600', fontSize: 13 },
  chipTextOn: { color: theme.colors.accent },
  optionalRow: { flexDirection: 'row', alignItems: 'center', marginTop: 14, gap: 10 },
  checkbox: {
    width: 18,
    height: 18,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: theme.colors.outline,
    backgroundColor: theme.colors.surface,
  },
  checkboxOn: { backgroundColor: theme.colors.accent, borderColor: theme.colors.accent },
  optionalText: { color: theme.colors.textMuted },
  error: { marginTop: 12, color: theme.colors.danger },
  formActions: { flexDirection: 'row', gap: 10, marginTop: 16, flexWrap: 'wrap' },
  primaryBtn: {
    backgroundColor: theme.colors.accent,
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: theme.radius.sm,
  },
  primaryBtnText: { color: theme.colors.accentOn, fontWeight: '700' },
  secondaryBtn: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: theme.radius.sm,
    backgroundColor: theme.colors.surfaceHighest,
  },
  secondaryBtnText: { color: theme.colors.textMuted, fontWeight: '600' },
});

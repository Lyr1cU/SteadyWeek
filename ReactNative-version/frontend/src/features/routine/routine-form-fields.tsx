import { Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { LIFE_SPHERES } from '../../domain/life-sphere';
import type { Effort, RoutineItemInput } from '../../domain/models';
import { toggleWeekdayMask, WEEKDAY_LABELS, weekdayMaskFromIndex } from '../../logic/weekdays';
import { strings } from '../../l10n';
import { sphereLabel } from '../../ui/sphere-ui';
import { theme } from '../../ui/theme';
import { TodayTaskCheckbox } from '../today/today-task-checkbox';
import { RoutineTimeField } from './routine-time-field';

const EFFORTS: Effort[] = ['light', 'medium', 'heavy'];

function effortCopy(effort: Effort): string {
  const copy = strings().routine;
  if (effort === 'light') return copy.effortLight;
  if (effort === 'heavy') return copy.effortHeavy;
  return copy.effortMedium;
}

export function RoutineFormFields({
  draft,
  error,
  onDraft,
}: {
  draft: RoutineItemInput;
  error: string | null;
  onDraft: (next: RoutineItemInput) => void;
}) {
  const copy = strings().routine;

  return (
    <>
      <Text style={styles.label}>{copy.labelTitle}</Text>
      <TextInput
        value={draft.title}
        onChangeText={(title) => onDraft({ ...draft, title })}
        placeholder={copy.titlePlaceholder}
        placeholderTextColor={theme.colors.textSubtle}
        style={styles.input}
      />

      <Text style={styles.label}>{copy.labelWeekdays}</Text>
      <View style={styles.weekdayRow}>
        {WEEKDAY_LABELS.map((label, index) => {
          const on = (draft.weekdays & weekdayMaskFromIndex(index)) !== 0;
          return (
            <Pressable
              key={label}
              onPress={() => onDraft({ ...draft, weekdays: toggleWeekdayMask(draft.weekdays, index) })}
              style={[styles.chip, on && styles.chipOn]}
            >
              <Text style={[styles.chipText, on && styles.chipTextOn]}>{label}</Text>
            </Pressable>
          );
        })}
      </View>

      <Text style={styles.label}>{copy.labelTime}</Text>
      <RoutineTimeField
        minute={draft.scheduledMinuteOfDay}
        onChange={(scheduledMinuteOfDay) => onDraft({ ...draft, scheduledMinuteOfDay })}
      />

      <Text style={styles.label}>{copy.labelSphere}</Text>
      <View style={styles.chipRow}>
        {LIFE_SPHERES.map((sphere) => {
          const on = draft.sphere === sphere;
          return (
            <Pressable
              key={sphere}
              onPress={() => onDraft({ ...draft, sphere })}
              style={[styles.chip, on && styles.chipOn]}
            >
              <Text style={[styles.chipText, on && styles.chipTextOn]}>{sphereLabel(sphere)}</Text>
            </Pressable>
          );
        })}
      </View>

      <Text style={styles.label}>{copy.labelEffort}</Text>
      <View style={styles.chipRow}>
        {EFFORTS.map((effort) => {
          const on = draft.effort === effort;
          return (
            <Pressable
              key={effort}
              onPress={() => onDraft({ ...draft, effort })}
              style={[styles.chip, on && styles.chipOn, effort === 'heavy' && on && styles.chipHeavyOn]}
            >
              <Text style={[styles.chipText, on && styles.chipTextOn]}>{effortCopy(effort)}</Text>
            </Pressable>
          );
        })}
      </View>

      <View style={styles.optionalRow}>
        <TodayTaskCheckbox
          checked={draft.isOptional}
          skipped={false}
          onPress={() => onDraft({ ...draft, isOptional: !draft.isOptional })}
        />
        <Pressable
          onPress={() => onDraft({ ...draft, isOptional: !draft.isOptional })}
          style={styles.optionalLabelTap}
        >
          <Text style={styles.optionalText}>{copy.optionalItem}</Text>
        </Pressable>
      </View>

      {error ? <Text style={styles.error}>{error}</Text> : null}
    </>
  );
}

const styles = StyleSheet.create({
  label: {
    marginTop: 12,
    marginBottom: 6,
    color: theme.colors.textMuted,
    fontWeight: '600',
    fontSize: 13,
  },
  input: {
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.2)',
    borderRadius: theme.radius.md,
    paddingHorizontal: 12,
    paddingVertical: 10,
    backgroundColor: 'rgba(8, 7, 14, 0.35)',
    color: theme.colors.text,
  },
  weekdayRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  chipRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  chip: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(53, 45, 85, 0.45)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  chipOn: {
    backgroundColor: theme.colors.accentContainer,
    borderColor: 'rgba(202, 184, 255, 0.45)',
  },
  chipHeavyOn: {
    backgroundColor: 'rgba(202, 184, 255, 0.22)',
  },
  chipText: { color: theme.colors.textMuted, fontWeight: '600', fontSize: 13 },
  chipTextOn: { color: theme.colors.accent },
  optionalRow: { flexDirection: 'row', alignItems: 'center', marginTop: 14, gap: 10 },
  optionalLabelTap: { flex: 1 },
  optionalText: { color: theme.colors.textMuted },
  error: { marginTop: 12, color: theme.colors.danger },
});

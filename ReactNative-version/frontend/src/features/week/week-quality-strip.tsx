import { Pressable, StyleSheet, Text, View } from 'react-native';
import type { DayTier } from '../../domain/day-tier';
import {
  addLocalDays,
  dateKey,
  localDayFromKey,
  startOfLocalDay,
} from '../../logic/calendar';
import { theme } from '../../ui/theme';

const WEEKDAY_SHORT = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

function tierFill(tier: DayTier | null | undefined): string {
  if (tier === 'green') return 'rgba(46, 125, 80, 0.35)';
  if (tier === 'yellow') return 'rgba(180, 140, 40, 0.35)';
  if (tier === 'red') return 'rgba(160, 60, 60, 0.35)';
  return theme.colors.surfaceHigh;
}

export function WeekQualityStrip({
  weekKey,
  tierByDayKey,
  onDayPress,
}: {
  weekKey: string;
  tierByDayKey: Record<string, DayTier | null | undefined>;
  onDayPress: (dayKey: string) => void;
}) {
  const monday = localDayFromKey(weekKey);
  const todayKey = dateKey(startOfLocalDay(new Date()));

  return (
    <View style={styles.wrap}>
      <Text style={styles.title}>Day quality</Text>
      <View style={styles.row}>
        {WEEKDAY_SHORT.map((label, i) => {
          const day = addLocalDays(monday, i);
          const key = dateKey(day);
          const tier = tierByDayKey[key];
          const isToday = key === todayKey;
          return (
            <Pressable
              key={key}
              style={[styles.chip, { backgroundColor: tierFill(tier) }, isToday && styles.chipToday]}
              onPress={() => onDayPress(key)}
            >
              <Text style={styles.chipLabel}>{label}</Text>
              <Text style={styles.chipDay}>{day.getDate()}</Text>
            </Pressable>
          );
        })}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { marginBottom: theme.spacing.section },
  title: {
    fontSize: 18,
    fontWeight: '700',
    color: theme.colors.text,
    marginBottom: 10,
  },
  row: { flexDirection: 'row', gap: 6 },
  chip: {
    flex: 1,
    borderRadius: 12,
    paddingVertical: 8,
    alignItems: 'center',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  chipToday: {
    borderColor: theme.colors.accent,
    borderWidth: 2,
  },
  chipLabel: { fontSize: 10, fontWeight: '600', color: theme.colors.textMuted },
  chipDay: { fontSize: 15, fontWeight: '700', color: theme.colors.text, marginTop: 2 },
});

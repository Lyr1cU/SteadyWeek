import { Pressable, StyleSheet, Text, View } from 'react-native';
import type { DayTier } from '../../domain/day-tier';
import {
  addLocalDays,
  dateKey,
  localDayFromKey,
  startOfLocalDay,
} from '../../logic/calendar';
import { strings } from '../../l10n';
import { theme } from '../../ui/theme';

const WEEKDAY_SHORT = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

function tierStyle(tier: DayTier | null | undefined): {
  backgroundColor: string;
  borderColor: string;
} {
  if (tier === 'green') {
    return {
      backgroundColor: 'rgba(134, 239, 172, 0.14)',
      borderColor: 'rgba(134, 239, 172, 0.35)',
    };
  }
  if (tier === 'yellow') {
    return {
      backgroundColor: 'rgba(252, 211, 77, 0.12)',
      borderColor: 'rgba(252, 211, 77, 0.32)',
    };
  }
  if (tier === 'red') {
    return {
      backgroundColor: 'rgba(252, 165, 165, 0.12)',
      borderColor: 'rgba(252, 165, 165, 0.32)',
    };
  }
  return {
    backgroundColor: theme.colors.surfaceHigh,
    borderColor: theme.colors.border,
  };
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
  const copy = strings().week;

  return (
    <View style={styles.wrap}>
      <Text style={styles.title}>{copy.dayQuality}</Text>
      <View style={styles.row}>
        {WEEKDAY_SHORT.map((label, i) => {
          const day = addLocalDays(monday, i);
          const key = dateKey(day);
          const tier = tierByDayKey[key];
          const isToday = key === todayKey;
          const isFuture = key > todayKey;
          const fill = tierStyle(tier);

          return (
            <Pressable
              key={key}
              disabled={isFuture}
              onPress={() => onDayPress(key)}
              style={({ pressed }) => [
                styles.chip,
                {
                  backgroundColor: fill.backgroundColor,
                  borderColor: isToday ? theme.colors.accent : fill.borderColor,
                  borderWidth: isToday ? 2 : StyleSheet.hairlineWidth,
                  opacity: isFuture ? 0.42 : pressed ? 0.88 : 1,
                },
              ]}
            >
              {isToday ? <View style={styles.todayDot} /> : null}
              <Text style={[styles.chipLabel, isFuture && styles.chipMuted]}>{label}</Text>
              <Text style={[styles.chipDay, isFuture && styles.chipMuted]}>{day.getDate()}</Text>
              {isToday ? <Text style={styles.todayTag}>{copy.todayMarker}</Text> : null}
            </Pressable>
          );
        })}
      </View>
      <View style={styles.legend}>
        <LegendDot color={theme.colors.success} label={copy.legendGreen} />
        <LegendDot color={theme.colors.warning} label={copy.legendYellow} />
        <LegendDot color={theme.colors.danger} label={copy.legendRed} />
      </View>
    </View>
  );
}

function LegendDot({ color, label }: { color: string; label: string }) {
  return (
    <View style={styles.legendItem}>
      <View style={[styles.legendDot, { backgroundColor: color }]} />
      <Text style={styles.legendText}>{label}</Text>
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
    paddingVertical: 6,
    paddingHorizontal: 2,
    alignItems: 'center',
    minHeight: 58,
    justifyContent: 'center',
  },
  todayDot: {
    position: 'absolute',
    top: 5,
    right: 6,
    width: 5,
    height: 5,
    borderRadius: 3,
    backgroundColor: theme.colors.accent,
  },
  chipLabel: { fontSize: 10, fontWeight: '600', color: theme.colors.textMuted },
  chipDay: { fontSize: 15, fontWeight: '700', color: theme.colors.text, marginTop: 2 },
  chipMuted: { color: theme.colors.textSubtle },
  todayTag: {
    marginTop: 2,
    fontSize: 8,
    fontWeight: '700',
    color: theme.colors.accent,
    letterSpacing: 0.3,
  },
  legend: {
    flexDirection: 'row',
    gap: 14,
    marginTop: 10,
    flexWrap: 'wrap',
  },
  legendItem: { flexDirection: 'row', alignItems: 'center', gap: 5 },
  legendDot: { width: 7, height: 7, borderRadius: 4 },
  legendText: { fontSize: 11, color: theme.colors.textSubtle, fontWeight: '600' },
});

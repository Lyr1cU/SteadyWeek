import { Pressable, StyleSheet, Text, View } from 'react-native';
import { dateKey } from '../../logic/calendar';
import { weekdayLabel } from '../../logic/weekdays';
import { theme } from '../../ui/theme';

export function TodayDateBar({
  date,
  isToday,
  onPrev,
  onNext,
  onJumpToday,
}: {
  date: Date;
  isToday: boolean;
  onPrev: () => void;
  onNext: () => void;
  onJumpToday: () => void;
}) {
  return (
    <View style={styles.wrap}>
      <View style={styles.row}>
        <Pressable onPress={onPrev} style={styles.arrow} accessibilityRole="button">
          <Text style={styles.arrowText}>‹</Text>
        </Pressable>
        <View style={styles.center}>
          <Text style={styles.weekday}>{weekdayLabel(date)}</Text>
          <Text style={styles.date}>{dateKey(date)}</Text>
        </View>
        <Pressable onPress={onNext} style={styles.arrow} accessibilityRole="button">
          <Text style={styles.arrowText}>›</Text>
        </Pressable>
      </View>
      {isToday ? null : (
        <Pressable onPress={onJumpToday} style={styles.jump}>
          <Text style={styles.jumpText}>Jump to today</Text>
        </Pressable>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { marginBottom: theme.spacing.section },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 12,
  },
  arrow: {
    width: 44,
    height: 44,
    borderRadius: theme.radius.md,
    backgroundColor: theme.colors.surfaceHighest,
    alignItems: 'center',
    justifyContent: 'center',
  },
  arrowText: { color: theme.colors.accent, fontSize: 28, fontWeight: '600', marginTop: -2 },
  center: { flex: 1, alignItems: 'center' },
  weekday: { color: theme.colors.text, fontSize: 18, fontWeight: '700' },
  date: { color: theme.colors.textSubtle, marginTop: 2, fontSize: 13 },
  jump: { marginTop: 10, alignItems: 'center' },
  jumpText: { color: theme.colors.accent, fontWeight: '600', fontSize: 14 },
});

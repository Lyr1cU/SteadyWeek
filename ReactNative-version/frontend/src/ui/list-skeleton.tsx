import { StyleSheet, Text, View } from 'react-native';
import { PulseBlock } from './motion/pulse-block';
import { theme } from './theme';

/** Placeholder rows while the first local read is in flight. */
export function ListSkeleton({
  rows = 4,
  variant,
}: {
  rows?: number;
  variant: 'today' | 'routine';
}) {
  return (
    <View accessibilityRole="progressbar" accessibilityLabel="Loading">
      <Text style={styles.label}>Loading</Text>
      {Array.from({ length: rows }, (_, index) =>
        variant === 'today' ? (
          <View key={index} style={styles.todayRow}>
            <PulseBlock style={[styles.block, styles.time]} />
            <PulseBlock style={[styles.block, styles.todayCard]} />
          </View>
        ) : (
          <PulseBlock key={index} style={[styles.block, styles.routineCard]} />
        ),
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  label: {
    marginBottom: 16,
    color: theme.colors.textSubtle,
    fontSize: 14,
    fontWeight: '600',
  },
  block: {
    backgroundColor: 'rgba(202, 184, 255, 0.14)',
    borderRadius: theme.radius.lg,
  },
  todayRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
    gap: 6,
  },
  time: {
    width: 72,
    height: 14,
    borderRadius: 7,
  },
  todayCard: {
    flex: 1,
    height: 72,
  },
  routineCard: {
    height: 88,
    marginBottom: 12,
  },
});

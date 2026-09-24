import { Pressable, StyleSheet, Text, View } from 'react-native';
import {
  addLocalDays,
  localDayFromKey,
  startOfLocalDay,
  weekKeyFromDate,
} from '../../logic/calendar';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function WeekNavBar({
  anchor,
  onPrev,
  onNext,
  onThisWeek,
}: {
  anchor: Date;
  onPrev: () => void;
  onNext: () => void;
  onThisWeek: () => void;
}) {
  const weekKey = weekKeyFromDate(anchor);
  const thisWeekKey = weekKeyFromDate(new Date());
  const isThisWeek = weekKey === thisWeekKey;
  const copy = strings().week;
  const monday = localDayFromKey(weekKey);
  const sunday = addLocalDays(monday, 6);

  const formatPart = (d: Date) =>
    d.toLocaleDateString(undefined, { month: 'short', day: 'numeric' });

  return (
    <GlassSurface style={styles.shell}>
      <View style={styles.inner}>
        <Pressable
          onPress={onPrev}
          style={({ pressed }) => [styles.arrow, pressed && styles.pressed]}
          accessibilityLabel={copy.previousWeek}
        >
          <Text style={styles.arrowText}>‹</Text>
        </Pressable>
        <View style={styles.center}>
          <Text style={styles.kicker}>{isThisWeek ? copy.thisWeek : copy.weekLabel}</Text>
          <Text style={styles.range}>
            {formatPart(monday)} – {formatPart(sunday)}
          </Text>
        </View>
        <Pressable
          onPress={onNext}
          style={({ pressed }) => [styles.arrow, pressed && styles.pressed]}
          accessibilityLabel={copy.nextWeek}
        >
          <Text style={styles.arrowText}>›</Text>
        </Pressable>
      </View>
      {!isThisWeek ? (
        <Pressable onPress={onThisWeek} style={styles.jump}>
          <Text style={styles.jumpText}>{copy.thisWeek}</Text>
        </Pressable>
      ) : null}
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  shell: { marginBottom: theme.spacing.stack, borderRadius: theme.radius.lg },
  inner: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 10,
    paddingHorizontal: 4,
    gap: 4,
  },
  arrow: {
    width: 44,
    height: 44,
    borderRadius: theme.radius.md,
    backgroundColor: theme.colors.surfaceHighest,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pressed: { opacity: 0.82 },
  arrowText: { color: theme.colors.accent, fontSize: 28, fontWeight: '600', marginTop: -2 },
  center: { flex: 1, alignItems: 'center' },
  kicker: { color: theme.colors.accentMuted, fontSize: 13, fontWeight: '600' },
  range: { color: theme.colors.text, fontWeight: '700', marginTop: 2, fontSize: 15 },
  jump: { paddingBottom: 10, alignItems: 'center' },
  jumpText: { color: theme.colors.accent, fontWeight: '700', fontSize: 14 },
});

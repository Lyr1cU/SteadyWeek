import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, Text, View } from 'react-native';
import type { DayItemStatus, TodayRoutineRow } from '../../domain/models';
import { formatTime12h } from '../../logic/time-of-day';
import { strings } from '../../l10n';
import { ChromeContextMenu } from '../../ui/chrome-context-menu';
import { GlassSurface } from '../../ui/glass-surface';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { sphereLabel, sphereSymbol } from '../../ui/sphere-ui';
import { theme } from '../../ui/theme';
import { TodayTaskCheckbox } from './today-task-checkbox';

export function TodayItem({
  row,
  onStatus,
}: {
  row: TodayRoutineRow;
  onStatus: (routineItemId: string, status: DayItemStatus) => void;
}) {
  const done = row.status === 'done';
  const skipped = row.status === 'skipped';
  const symbol = sphereSymbol(row.item.sphere);
  const copy = strings().routine;
  const showMenu = !done || skipped;

  const toggleDone = () => {
    if (skipped) {
      onStatus(row.item.id, 'pending');
      return;
    }
    onStatus(row.item.id, done ? 'pending' : 'done');
  };

  const menuItems = skipped
    ? [
        {
          key: 'undo',
          label: copy.undoSkip,
          icon: <Ionicons name="arrow-undo-outline" size={22} color={theme.colors.accent} />,
          onPress: () => onStatus(row.item.id, 'pending'),
        },
      ]
    : [
        {
          key: 'skip',
          label: copy.skipToday,
          icon: <Ionicons name="calendar-clear-outline" size={22} color={theme.colors.accent} />,
          onPress: () => onStatus(row.item.id, 'skipped'),
        },
      ];

  return (
    <View style={styles.row}>
      <Text style={styles.timeCol}>{formatTime12h(row.item.scheduledMinuteOfDay)}</Text>
      <GlassSurface style={[styles.card, skipped && styles.cardSkipped]}>
        <View style={styles.cardInner}>
          <AnimatedPressable style={styles.mainTap} onPress={toggleDone}>
            <View style={styles.iconWrap}>
              <Text style={styles.sphereSymbol}>{symbol}</Text>
            </View>
            <View style={styles.textCol}>
              <Text
                style={[styles.title, (done || skipped) && styles.titleMuted]}
                numberOfLines={2}
              >
                {row.item.title}
              </Text>
              <Text style={styles.subtitle}>
                {skipped ? copy.skippedToday : sphereLabel(row.item.sphere)}
              </Text>
            </View>
          </AnimatedPressable>
          <TodayTaskCheckbox checked={done} skipped={skipped} onPress={toggleDone} />
          {showMenu ? (
            <ChromeContextMenu
              items={menuItems}
              trigger={(open) => (
                <AnimatedPressable onPress={open} style={styles.menuBtn} hitSlop={8}>
                  <Ionicons name="ellipsis-vertical" size={18} color={theme.colors.textSubtle} />
                </AnimatedPressable>
              )}
            />
          ) : (
            <View style={styles.menuPlaceholder} />
          )}
        </View>
      </GlassSurface>
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: 10,
    gap: 6,
  },
  timeCol: {
    width: 72,
    paddingTop: 18,
    fontSize: 13,
    fontWeight: '600',
    color: theme.colors.accentMuted,
  },
  card: {
    flex: 1,
    padding: 0,
  },
  cardSkipped: {
    opacity: 0.72,
  },
  cardInner: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    paddingHorizontal: 12,
    gap: 10,
  },
  mainTap: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    minWidth: 0,
  },
  iconWrap: {
    width: 28,
    alignItems: 'center',
  },
  sphereSymbol: {
    fontSize: 20,
    color: theme.colors.accentMuted,
    fontWeight: '600',
  },
  textCol: {
    flex: 1,
    minWidth: 0,
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.text,
    lineHeight: 22,
  },
  titleMuted: {
    textDecorationLine: 'line-through',
    color: theme.colors.textMuted,
  },
  subtitle: {
    marginTop: 2,
    fontSize: 13,
    color: theme.colors.textSubtle,
  },
  menuBtn: {
    paddingLeft: 2,
    minWidth: 28,
    alignItems: 'center',
    justifyContent: 'center',
  },
  menuPlaceholder: {
    width: 28,
  },
});

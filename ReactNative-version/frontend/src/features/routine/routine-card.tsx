import { Ionicons } from '@expo/vector-icons';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import type { RoutineItem } from '../../domain/models';
import { formatMinuteOfDay } from '../../logic/time-of-day';
import { formatWeekdaysMask } from '../../logic/weekdays';
import { strings } from '../../l10n';
import { ChromeContextMenu } from '../../ui/chrome-context-menu';
import { GlassSurface } from '../../ui/glass-surface';
import { sphereLabel, sphereSymbol } from '../../ui/sphere-ui';
import { theme } from '../../ui/theme';

function effortLabel(effort: RoutineItem['effort']): string {
  const copy = strings().routine;
  if (effort === 'light') return copy.effortLight;
  if (effort === 'heavy') return copy.effortHeavy;
  return copy.effortMedium;
}

function metaLine(item: RoutineItem): string {
  const copy = strings().routine;
  const time =
    item.scheduledMinuteOfDay == null
      ? copy.anyTime
      : formatMinuteOfDay(item.scheduledMinuteOfDay);
  return `${time} · ${sphereLabel(item.sphere)} · ${formatWeekdaysMask(item.weekdays)} · ${effortLabel(item.effort)}`;
}

export function RoutineCard({
  item,
  active,
  onEdit,
  onDelete,
}: {
  item: RoutineItem;
  active: boolean;
  onEdit: () => void;
  onDelete: () => void;
}) {
  const copy = strings().routine;
  const menuItems = [
    {
      key: 'edit',
      label: copy.editItem,
      icon: <Ionicons name="create-outline" size={22} color={theme.colors.accent} />,
      onPress: onEdit,
    },
    {
      key: 'delete',
      label: copy.deleteItem,
      icon: <Ionicons name="trash-outline" size={22} color={theme.colors.danger} />,
      onPress: onDelete,
    },
  ];

  return (
    <GlassSurface style={[styles.card, active && styles.cardActive]}>
      <View style={styles.inner}>
        <Pressable
          onPress={onEdit}
          style={({ pressed }) => [styles.main, pressed && styles.pressed]}
        >
          <View style={styles.iconWrap}>
            <Text style={styles.symbol}>{sphereSymbol(item.sphere)}</Text>
          </View>
          <View style={styles.textCol}>
            <View style={styles.titleRow}>
              <Text style={styles.title} numberOfLines={2}>
                {item.title}
              </Text>
              {item.isOptional ? (
                <View style={styles.optionalBadge}>
                  <Text style={styles.optionalBadgeText}>{copy.optionalBadge}</Text>
                </View>
              ) : null}
            </View>
            <Text style={styles.meta} numberOfLines={2}>
              {metaLine(item)}
            </Text>
          </View>
        </Pressable>
        <ChromeContextMenu
          items={menuItems}
          trigger={(open) => (
            <Pressable onPress={open} style={styles.menuBtn} hitSlop={8}>
              <Ionicons name="ellipsis-vertical" size={18} color={theme.colors.textSubtle} />
            </Pressable>
          )}
        />
      </View>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: { marginBottom: 10, borderRadius: theme.radius.lg },
  cardActive: {
    borderWidth: 1.5,
    borderColor: 'rgba(202, 184, 255, 0.55)',
  },
  inner: { flexDirection: 'row', alignItems: 'flex-start', padding: 14, gap: 8 },
  main: { flex: 1, flexDirection: 'row', gap: 10, minWidth: 0 },
  pressed: { opacity: 0.9 },
  iconWrap: { width: 28, alignItems: 'center', paddingTop: 2 },
  symbol: { fontSize: 20, color: theme.colors.accentMuted, fontWeight: '600' },
  textCol: { flex: 1, minWidth: 0 },
  titleRow: { flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', gap: 8 },
  title: { fontSize: 16, fontWeight: '600', color: theme.colors.text, flexShrink: 1 },
  optionalBadge: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(202, 184, 255, 0.12)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(202, 184, 255, 0.25)',
  },
  optionalBadgeText: { fontSize: 11, fontWeight: '600', color: theme.colors.textSubtle },
  meta: { marginTop: 4, color: theme.colors.textMuted, fontSize: 13, lineHeight: 18 },
  menuBtn: { paddingTop: 2, minWidth: 28, alignItems: 'center' },
});

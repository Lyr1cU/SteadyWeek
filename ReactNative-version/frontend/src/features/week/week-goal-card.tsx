import { Ionicons } from '@expo/vector-icons';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import type { WeeklyGoal } from '../../domain/models';
import { strings } from '../../l10n';
import { ChromeContextMenu } from '../../ui/chrome-context-menu';
import { GlassSurface } from '../../ui/glass-surface';
import { sphereLabel } from '../../ui/sphere-ui';
import { theme } from '../../ui/theme';

export function WeekGoalCard({
  goal,
  onEdit,
  onRemove,
}: {
  goal: WeeklyGoal;
  onEdit: () => void;
  onRemove: () => void;
}) {
  const copy = strings().week;
  const target = goal.targetCount <= 0 ? 1 : goal.targetCount;
  const progress = Math.min(goal.progressCount, target);
  const ratio = progress / target;

  const menuItems = [
    {
      key: 'edit',
      label: copy.editGoal,
      icon: <Ionicons name="create-outline" size={22} color={theme.colors.accent} />,
      onPress: onEdit,
    },
    {
      key: 'remove',
      label: copy.removeGoal,
      icon: <Ionicons name="trash-outline" size={22} color={theme.colors.danger} />,
      onPress: onRemove,
    },
  ];

  return (
    <GlassSurface style={styles.card}>
      <View style={styles.inner}>
        <Pressable
          onPress={onEdit}
          style={({ pressed }) => [styles.main, pressed && styles.pressed]}
        >
          <Text style={styles.title}>{goal.title}</Text>
          <Text style={styles.meta}>
            {sphereLabel(goal.sphere)} · {progress}/{target}
            {goal.status === 'completed' ? ` · ${copy.completed}` : ''}
          </Text>
          <View style={styles.track}>
            <View
              style={[
                styles.fill,
                { width: `${Math.round(ratio * 100)}%`, minWidth: ratio > 0 ? 4 : 0 },
              ]}
            />
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
  inner: { flexDirection: 'row', alignItems: 'flex-start', padding: 14, gap: 8 },
  main: { flex: 1, minWidth: 0 },
  pressed: { opacity: 0.9 },
  title: { fontSize: 16, fontWeight: '600', color: theme.colors.text },
  meta: { marginTop: 4, color: theme.colors.textMuted, fontSize: 13 },
  track: {
    marginTop: 10,
    height: 6,
    borderRadius: 3,
    backgroundColor: 'rgba(202, 184, 255, 0.12)',
    overflow: 'hidden',
  },
  fill: {
    height: '100%',
    borderRadius: 3,
    backgroundColor: theme.colors.accentMuted,
  },
  menuBtn: {
    paddingTop: 2,
    minWidth: 28,
    alignItems: 'center',
  },
});

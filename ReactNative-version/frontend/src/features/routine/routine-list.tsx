import { StyleSheet, Text, View } from 'react-native';
import type { RoutineItem } from '../../domain/models';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { StaggerFadeIn } from '../../ui/motion/stagger-fade-in';
import { theme } from '../../ui/theme';
import { RoutineCard } from './routine-card';

export function RoutineList({
  items,
  editingId,
  onEdit,
  onDelete,
  onExpandAdd,
}: {
  items: RoutineItem[];
  editingId: string | null;
  onEdit: (item: RoutineItem) => void;
  onDelete: (item: RoutineItem) => void;
  onExpandAdd: () => void;
}) {
  const copy = strings().routine;

  if (items.length === 0) {
    return (
      <StaggerFadeIn index={0}>
        <GlassSurface style={styles.emptyCard}>
          <Text style={styles.emptyText}>{copy.emptyList}</Text>
          <AnimatedPressable onPress={onExpandAdd} style={styles.emptyLink}>
            <Text style={styles.emptyLinkText}>+ {copy.addItem}</Text>
          </AnimatedPressable>
        </GlassSurface>
      </StaggerFadeIn>
    );
  }

  return (
    <View style={styles.list}>
      {items.map((item, index) => (
        <StaggerFadeIn key={item.id} index={index}>
          <RoutineCard
            item={item}
            active={editingId === item.id}
            onEdit={() => onEdit(item)}
            onDelete={() => onDelete(item)}
          />
        </StaggerFadeIn>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  list: { marginBottom: 12 },
  emptyCard: { padding: 16, borderRadius: theme.radius.lg, marginBottom: 12 },
  emptyText: { color: theme.colors.textMuted, lineHeight: 21 },
  emptyLink: { marginTop: 12, alignSelf: 'flex-start' },
  emptyLinkText: { color: theme.colors.accent, fontWeight: '700', fontSize: 15 },
});

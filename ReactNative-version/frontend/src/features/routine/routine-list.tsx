import { Platform, Pressable, StyleSheet, Text, View } from 'react-native';
import type { RoutineItem } from '../../domain/models';
import { formatWeekdaysMask } from '../../logic/weekdays';
import { formatMinuteOfDay } from '../../logic/time-of-day';
import { theme } from '../../ui/theme';

export function RoutineList({
  items,
  editingId,
  onEdit,
  onDelete,
}: {
  items: RoutineItem[];
  editingId: string | null;
  onEdit: (item: RoutineItem) => void;
  onDelete: (id: string) => void;
}) {
  const isWeb = Platform.OS === 'web';

  return (
    <View style={[styles.table, isWeb && styles.tableWeb]}>
      {isWeb ? (
        <View style={[styles.tableHead, styles.tableRowWeb]}>
          <Text style={[styles.headCell, styles.colTitle]}>Title</Text>
          <Text style={[styles.headCell, styles.colDays]}>Days</Text>
          <Text style={[styles.headCell, styles.colTime]}>Time</Text>
          <Text style={[styles.headCell, styles.colSphere]}>Sphere</Text>
          <Text style={[styles.headCell, styles.colEffort]}>Effort</Text>
          <Text style={[styles.headCell, styles.colActions]}> </Text>
        </View>
      ) : null}

      {items.length === 0 ? (
        <Text style={styles.empty}>No routine items yet. Add one below.</Text>
      ) : (
        items.map((item) => (
          <View
            key={item.id}
            style={[
              styles.tableRow,
              isWeb && styles.tableRowWeb,
              editingId === item.id && styles.tableRowActive,
            ]}
          >
            <Text style={[styles.cell, styles.colTitle]} numberOfLines={2}>
              {item.title}
              {item.isOptional ? ' (optional)' : ''}
            </Text>
            <Text style={[styles.cell, styles.colDays]}>{formatWeekdaysMask(item.weekdays)}</Text>
            <Text style={[styles.cell, styles.colTime]}>
              {formatMinuteOfDay(item.scheduledMinuteOfDay)}
            </Text>
            <Text style={[styles.cell, styles.colSphere]}>{item.sphere}</Text>
            <Text style={[styles.cell, styles.colEffort]}>{item.effort}</Text>
            <View style={[styles.actions, styles.colActions]}>
              <Pressable onPress={() => onEdit(item)} style={styles.smallBtn}>
                <Text style={styles.smallBtnText}>Edit</Text>
              </Pressable>
              <Pressable onPress={() => onDelete(item.id)} style={styles.smallBtnDanger}>
                <Text style={styles.smallBtnDangerText}>Delete</Text>
              </Pressable>
            </View>
          </View>
        ))
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  table: {
    backgroundColor: theme.colors.surfaceHigh,
    borderRadius: theme.radius.md,
    padding: 12,
    marginBottom: 20,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  tableWeb: { minWidth: 720 },
  tableHead: {
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: theme.colors.border,
    paddingBottom: 8,
    marginBottom: 4,
  },
  tableRow: {
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: theme.colors.border,
    paddingVertical: 12,
    gap: 4,
  },
  tableRowWeb: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  tableRowActive: { backgroundColor: theme.colors.accentContainer },
  headCell: { fontSize: 12, fontWeight: '700', color: theme.colors.textSubtle },
  cell: { fontSize: 14, color: theme.colors.text },
  colTitle: { flex: 2, minWidth: 140 },
  colDays: { flex: 1.4, minWidth: 120 },
  colTime: { width: 72 },
  colSphere: { width: 72 },
  colEffort: { width: 72 },
  colActions: { width: 132 },
  actions: { flexDirection: 'row', gap: 8 },
  empty: { color: theme.colors.textMuted, paddingVertical: 8 },
  smallBtn: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: theme.radius.sm,
    backgroundColor: theme.colors.accentContainer,
  },
  smallBtnText: { color: theme.colors.accent, fontWeight: '600', fontSize: 12 },
  smallBtnDanger: {
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: theme.radius.sm,
    backgroundColor: theme.colors.dangerBg,
  },
  smallBtnDangerText: { color: theme.colors.danger, fontWeight: '600', fontSize: 12 },
});

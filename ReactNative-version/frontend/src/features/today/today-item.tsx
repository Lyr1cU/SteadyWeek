import { Pressable, StyleSheet, Text, View } from 'react-native';
import type { DayItemStatus, TodayRoutineRow } from '../../domain/models';
import { formatMinuteOfDay } from '../../logic/time-of-day';
import { theme } from '../../ui/theme';

const STATUS_LABELS: Record<DayItemStatus, string> = {
  pending: 'Pending',
  done: 'Done',
  skipped: 'Skipped',
};

const STATUS_STYLE: Record<DayItemStatus, { bg: string; text: string }> = {
  pending: { bg: theme.colors.surfaceHighest, text: theme.colors.textMuted },
  done: { bg: theme.colors.successBg, text: theme.colors.successText },
  skipped: { bg: theme.colors.warningBg, text: theme.colors.warningText },
};

export function TodayItem({
  row,
  onStatus,
}: {
  row: TodayRoutineRow;
  onStatus: (routineItemId: string, status: DayItemStatus) => void;
}) {
  return (
    <View style={styles.row}>
      <View style={styles.rowHeader}>
        <Text style={styles.rowTitle}>{row.item.title}</Text>
        <View style={[styles.statusBadge, { backgroundColor: STATUS_STYLE[row.status].bg }]}>
          <Text style={[styles.statusBadgeText, { color: STATUS_STYLE[row.status].text }]}>
            {STATUS_LABELS[row.status]}
          </Text>
        </View>
      </View>
      <Text style={styles.meta}>
        {row.item.sphere} · {row.item.effort}
        {row.item.scheduledMinuteOfDay != null
          ? ` · ${formatMinuteOfDay(row.item.scheduledMinuteOfDay)}`
          : ''}
      </Text>
      <View style={styles.actions}>
        {(['done', 'skipped', 'pending'] as const).map((status) => (
          <Pressable
            key={status}
            onPress={() => onStatus(row.item.id, status)}
            style={[styles.actionBtn, row.status === status && styles.actionBtnOn]}
          >
            <Text
              style={[styles.actionBtnText, row.status === status && styles.actionBtnTextOn]}
            >
              {STATUS_LABELS[status]}
            </Text>
          </Pressable>
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    backgroundColor: theme.colors.surfaceHigh,
    padding: 14,
    borderRadius: theme.radius.lg,
    marginBottom: 10,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  rowHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    gap: 8,
  },
  rowTitle: { flex: 1, fontSize: 16, fontWeight: '600', color: theme.colors.text },
  statusBadge: {
    borderRadius: theme.radius.pill,
    paddingHorizontal: 10,
    paddingVertical: 4,
  },
  statusBadgeText: { fontSize: 12, fontWeight: '700' },
  meta: { marginTop: 4, color: theme.colors.textMuted, fontSize: 13 },
  actions: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginTop: 12 },
  actionBtn: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: theme.radius.pill,
    backgroundColor: theme.colors.surfaceHighest,
  },
  actionBtnOn: { backgroundColor: theme.colors.accentContainer },
  actionBtnText: { color: theme.colors.textMuted, fontWeight: '600', fontSize: 12 },
  actionBtnTextOn: { color: theme.colors.accent },
});

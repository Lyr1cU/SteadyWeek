import { useCallback, useEffect, useMemo, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import type { WeeklyGoal } from '../../domain/models';
import {
  addLocalDays,
  dayKeysForWeek,
  localDayFromKey,
  startOfLocalDay,
  weekKeyFromDate,
} from '../../logic/calendar';
import { GlassSurface } from '../../ui/glass-surface';
import { sphereLabel } from '../../ui/sphere-ui';
import { theme } from '../../ui/theme';
import { GoalEditorModal } from './goal-editor-modal';
import { WeekQualityStrip } from './week-quality-strip';

export function WeekScreen({
  onWeeklyReport,
  onOpenDay,
}: {
  onWeeklyReport: (weekKey: string) => void;
  onOpenDay: (dayKey: string) => void;
}) {
  const { goals, reports } = useRepos();
  const { syncRevision } = useSync();
  const [anchor, setAnchor] = useState(() => startOfLocalDay(new Date()));
  const weekKey = weekKeyFromDate(anchor);
  const [items, setItems] = useState<WeeklyGoal[]>([]);
  const [tierByDayKey, setTierByDayKey] = useState<Record<string, 'green' | 'yellow' | 'red' | null>>(
    {},
  );
  const [editorOpen, setEditorOpen] = useState(false);
  const [editing, setEditing] = useState<WeeklyGoal | null>(null);

  const dayKeys = useMemo(() => dayKeysForWeek(weekKey), [weekKey]);
  const thisWeekKey = weekKeyFromDate(new Date());
  const isThisWeek = weekKey === thisWeekKey;

  const reload = useCallback(async () => {
    const goalList = await goals.listForWeek(weekKey);
    setItems(goalList);
    const daily = await reports.listDailyInWeek(weekKey, dayKeys);
    const map: Record<string, 'green' | 'yellow' | 'red' | null> = {};
    for (const k of dayKeys) {
      map[k] = null;
    }
    for (const r of daily) {
      map[r.dayKey] = r.dayTier;
    }
    setTierByDayKey(map);
  }, [goals, reports, weekKey, dayKeys]);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

  const openAdd = () => {
    setEditing(null);
    setEditorOpen(true);
  };

  const openEdit = (goal: WeeklyGoal) => {
    setEditing(goal);
    setEditorOpen(true);
  };

  return (
    <>
      <ScrollView style={styles.wrap} contentContainerStyle={styles.content}>
        <View style={styles.weekNav}>
          <Pressable onPress={() => setAnchor((d) => addLocalDays(d, -7))}>
            <Text style={styles.navBtn}>←</Text>
          </Pressable>
          <View style={styles.weekNavCenter}>
            <Text style={styles.kicker}>{isThisWeek ? 'This week' : 'Week'}</Text>
            <Text style={styles.weekRange}>
              {localDayFromKey(weekKey).toLocaleDateString(undefined, {
                month: 'short',
                day: 'numeric',
              })}
              {' – '}
              {addLocalDays(localDayFromKey(weekKey), 6).toLocaleDateString(undefined, {
                month: 'short',
                day: 'numeric',
              })}
            </Text>
          </View>
          <Pressable onPress={() => setAnchor((d) => addLocalDays(d, 7))}>
            <Text style={styles.navBtn}>→</Text>
          </Pressable>
        </View>
        <Text style={styles.title}>Week</Text>

        <WeekQualityStrip weekKey={weekKey} tierByDayKey={tierByDayKey} onDayPress={onOpenDay} />

        <View style={styles.goalsHeader}>
          <Text style={styles.goalsTitle}>Weekly goals</Text>
          <Pressable onPress={openAdd}>
            <Text style={styles.addLink}>+ Add</Text>
          </Pressable>
        </View>

        {items.length === 0 ? (
          <Text style={styles.empty}>No goals yet. Add one or two for this week.</Text>
        ) : (
          items.map((goal) => {
            const t = goal.targetCount <= 0 ? 1 : goal.targetCount;
            const p = Math.min(goal.progressCount, t);
            return (
              <GlassSurface key={goal.id} style={styles.card}>
                <View style={styles.cardInner}>
                  <Pressable onPress={() => openEdit(goal)}>
                    <Text style={styles.cardTitle}>{goal.title}</Text>
                    <Text style={styles.meta}>
                      {sphereLabel(goal.sphere)} · {p}/{t}
                      {goal.status === 'completed' ? ' · done' : ''}
                    </Text>
                  </Pressable>
                  <Pressable onPress={() => void goals.delete(goal.id).then(() => reload())}>
                    <Text style={styles.delete}>Remove</Text>
                  </Pressable>
                </View>
              </GlassSurface>
            );
          })
        )}

        <Pressable style={styles.link} onPress={() => onWeeklyReport(weekKey)}>
          <Text style={styles.linkText}>Weekly report</Text>
        </Pressable>
      </ScrollView>

      <GoalEditorModal
        visible={editorOpen}
        weekKey={weekKey}
        editing={editing}
        onClose={() => setEditorOpen(false)}
        onSave={async (input) => {
          if (editing) {
            await goals.update(editing.id, input);
          } else {
            await goals.add(input);
          }
          await reload();
        }}
      />
    </>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1, backgroundColor: 'transparent' },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  weekNav: { flexDirection: 'row', alignItems: 'center', marginBottom: 8 },
  navBtn: { fontSize: 22, color: theme.colors.accent, paddingHorizontal: 8 },
  weekNavCenter: { flex: 1, alignItems: 'center' },
  kicker: { color: theme.colors.textSubtle, fontSize: 13 },
  weekRange: { color: theme.colors.textMuted, fontWeight: '600' },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text, marginBottom: 16 },
  goalsHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  goalsTitle: { fontSize: 18, fontWeight: '700', color: theme.colors.text },
  addLink: { color: theme.colors.accent, fontWeight: '700' },
  empty: { color: theme.colors.textMuted, marginBottom: 16 },
  card: { marginBottom: 10, borderRadius: 16 },
  cardInner: { padding: 14, flexDirection: 'row', alignItems: 'center', gap: 12 },
  cardTitle: { fontSize: 16, fontWeight: '600', color: theme.colors.text },
  meta: { marginTop: 4, color: theme.colors.textMuted, fontSize: 13 },
  delete: { color: theme.colors.textSubtle, fontSize: 13 },
  link: { marginTop: 16 },
  linkText: { color: theme.colors.accent, fontWeight: '600', fontSize: 16 },
});

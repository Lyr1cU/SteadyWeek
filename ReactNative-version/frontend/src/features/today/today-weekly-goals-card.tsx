import { useCallback, useEffect, useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import type { WeeklyGoal } from '../../domain/models';
import { weekKeyFromDate } from '../../logic/calendar';
import { GlassSurface } from '../../ui/glass-surface';
import { sphereLabel } from '../../ui/sphere-ui';
import { theme } from '../../ui/theme';

export function TodayWeeklyGoalsCard({
  date,
  onWeek,
  onChanged,
}: {
  date: Date;
  onWeek?: () => void;
  onChanged?: () => void;
}) {
  const { goals } = useRepos();
  const { syncRevision } = useSync();
  const weekKey = weekKeyFromDate(date);
  const [items, setItems] = useState<WeeklyGoal[]>([]);

  const reload = useCallback(async () => {
    setItems(await goals.listForWeek(weekKey));
  }, [goals, weekKey]);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

  const bump = async (id: string) => {
    await goals.bumpProgress(id, 1);
    await reload();
    onChanged?.();
  };

  return (
    <GlassSurface style={styles.card}>
      <View style={styles.inner}>
        <Text style={styles.title}>Weekly goals</Text>
        {items.length === 0 ? (
          <Text style={styles.body}>No goals for this week yet. Add them on the Week tab.</Text>
        ) : (
          items.map((g) => {
            const t = g.targetCount <= 0 ? 1 : g.targetCount;
            const p = Math.min(g.progressCount, t);
            const done = g.status === 'completed' || p >= t;
            return (
              <View key={g.id} style={styles.row}>
                <View style={styles.rowText}>
                  <Text style={styles.goalTitle}>{g.title}</Text>
                  <Text style={styles.meta}>
                    {sphereLabel(g.sphere)} · {p}/{t}
                  </Text>
                </View>
                {!done ? (
                  <Pressable style={styles.bump} onPress={() => void bump(g.id)}>
                    <Text style={styles.bumpText}>+1</Text>
                  </Pressable>
                ) : (
                  <Text style={styles.doneMark}>✓</Text>
                )}
              </View>
            );
          })
        )}
        {onWeek ? (
          <Pressable onPress={onWeek}>
            <Text style={styles.link}>Week</Text>
          </Pressable>
        ) : null}
      </View>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: theme.spacing.section,
    borderRadius: 16,
  },
  inner: {
    padding: 14,
  },
  title: {
    fontSize: 18,
    fontWeight: '700',
    color: theme.colors.text,
    marginBottom: 8,
  },
  body: {
    color: theme.colors.textMuted,
    lineHeight: 20,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
    gap: 10,
  },
  rowText: { flex: 1 },
  goalTitle: { color: theme.colors.text, fontWeight: '600' },
  meta: { color: theme.colors.textMuted, fontSize: 13, marginTop: 2 },
  bump: {
    backgroundColor: theme.colors.accentContainer,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
  },
  bumpText: { color: theme.colors.accent, fontWeight: '700' },
  doneMark: { color: theme.colors.accent, fontSize: 18, fontWeight: '700' },
  link: {
    marginTop: 10,
    color: theme.colors.accent,
    fontWeight: '600',
  },
});

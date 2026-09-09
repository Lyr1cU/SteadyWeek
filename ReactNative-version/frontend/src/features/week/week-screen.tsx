import { useCallback, useEffect, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useRepos } from '../../app/repos-context';
import type { WeeklyGoal } from '../../domain/models';
import { weekKeyFromDate } from '../../logic/calendar';
import { theme } from '../../ui/theme';

export function WeekScreen({ onWeeklyReport }: { onWeeklyReport: () => void }) {
  const { goals } = useRepos();
  const [weekKey] = useState(() => weekKeyFromDate(new Date()));
  const [items, setItems] = useState<WeeklyGoal[]>([]);

  const reload = useCallback(async () => {
    setItems(await goals.listForWeek(weekKey));
  }, [goals, weekKey]);

  useEffect(() => {
    void reload();
  }, [reload]);

  return (
    <ScrollView style={styles.wrap} contentContainerStyle={styles.content}>
      <Text style={styles.kicker}>Week of {weekKey}</Text>
      <Text style={styles.title}>Week</Text>
      <Text style={styles.subtitle}>
        Goals and the day-quality strip land in phase 4. The week key already matches MASTER_PLAN.
      </Text>
      {items.length === 0 ? (
        <Text style={styles.empty}>No weekly goals yet.</Text>
      ) : (
        items.map((goal) => (
          <View key={goal.id} style={styles.card}>
            <Text style={styles.cardTitle}>{goal.title}</Text>
            <Text style={styles.meta}>
              {goal.sphere} · {goal.progressCount}/{goal.targetCount}
            </Text>
          </View>
        ))
      )}
      <Pressable style={styles.link} onPress={onWeeklyReport}>
        <Text style={styles.linkText}>Weekly report</Text>
      </Pressable>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1, backgroundColor: 'transparent' },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  kicker: { color: theme.colors.textSubtle, marginBottom: 4 },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  subtitle: { marginTop: 6, marginBottom: 20, color: theme.colors.textMuted },
  empty: { color: theme.colors.textMuted, marginBottom: 20 },
  card: {
    backgroundColor: theme.colors.surfaceHigh,
    padding: 14,
    borderRadius: theme.radius.lg,
    marginBottom: 10,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  cardTitle: { fontSize: 16, fontWeight: '600', color: theme.colors.text },
  meta: { marginTop: 4, color: theme.colors.textMuted, fontSize: 13 },
  link: { marginTop: 8 },
  linkText: { color: theme.colors.accent, fontWeight: '600', fontSize: 16 },
});

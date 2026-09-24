import { useCallback, useEffect, useMemo, useState } from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import type { WeeklyGoal } from '../../domain/models';
import {
  addLocalDays,
  dayKeysForWeek,
  startOfLocalDay,
  weekKeyFromDate,
} from '../../logic/calendar';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { StaggerFadeIn } from '../../ui/motion/stagger-fade-in';
import { theme } from '../../ui/theme';
import { GoalEditorModal } from './goal-editor-modal';
import { WeekGoalCard } from './week-goal-card';
import { WeekNavBar } from './week-nav-bar';
import { WeekQualityStrip } from './week-quality-strip';
import { WeekReportCta } from './week-report-cta';

/** Match floating tab dock clearance in main-shell. */

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
  const copy = strings().week;

  const dayKeys = useMemo(() => dayKeysForWeek(weekKey), [weekKey]);

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
        <StaggerFadeIn index={0}>
          <WeekNavBar
            anchor={anchor}
            onPrev={() => setAnchor((d) => addLocalDays(d, -7))}
            onNext={() => setAnchor((d) => addLocalDays(d, 7))}
            onThisWeek={() => setAnchor(startOfLocalDay(new Date()))}
          />
        </StaggerFadeIn>

        <StaggerFadeIn index={1}>
          <Text style={styles.title}>{copy.weekLabel}</Text>
        </StaggerFadeIn>

        <StaggerFadeIn index={2}>
          <WeekQualityStrip weekKey={weekKey} tierByDayKey={tierByDayKey} onDayPress={onOpenDay} />
        </StaggerFadeIn>

        <StaggerFadeIn index={3}>
          <View style={styles.goalsHeader}>
            <Text style={styles.goalsTitle}>{copy.weeklyGoals}</Text>
            <AnimatedPressable onPress={openAdd} style={styles.addPill}>
              <Text style={styles.addPillText}>+ {copy.addGoal}</Text>
            </AnimatedPressable>
          </View>
        </StaggerFadeIn>

        {items.length === 0 ? (
          <StaggerFadeIn index={4}>
            <GlassSurface style={styles.emptyCard}>
              <Text style={styles.emptyText}>{copy.emptyGoals}</Text>
              <AnimatedPressable onPress={openAdd} style={styles.emptyLink}>
                <Text style={styles.emptyLinkText}>+ {copy.addGoal}</Text>
              </AnimatedPressable>
            </GlassSurface>
          </StaggerFadeIn>
        ) : (
          items.map((goal, index) => (
            <StaggerFadeIn key={goal.id} index={index + 4}>
              <WeekGoalCard
                goal={goal}
                onEdit={() => openEdit(goal)}
                onRemove={() => void goals.delete(goal.id).then(() => reload())}
              />
            </StaggerFadeIn>
          ))
        )}

        <StaggerFadeIn index={items.length + 5}>
          <WeekReportCta onPress={() => onWeeklyReport(weekKey)} />
        </StaggerFadeIn>
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
    paddingBottom: 24,
  },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text, marginBottom: 16 },
  goalsHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  goalsTitle: { fontSize: 18, fontWeight: '700', color: theme.colors.text },
  addPill: {
    paddingVertical: 6,
    paddingHorizontal: 12,
    borderRadius: theme.radius.pill,
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.35)',
    backgroundColor: 'rgba(53, 45, 85, 0.45)',
  },
  addPillText: { color: theme.colors.accent, fontWeight: '700', fontSize: 14 },
  emptyCard: { padding: 16, borderRadius: theme.radius.lg, marginBottom: 4 },
  emptyText: { color: theme.colors.textMuted, lineHeight: 21 },
  emptyLink: { marginTop: 12, alignSelf: 'flex-start' },
  emptyLinkText: { color: theme.colors.accent, fontWeight: '700', fontSize: 15 },
});

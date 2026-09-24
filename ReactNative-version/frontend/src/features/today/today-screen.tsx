import { useCallback, useEffect, useState } from 'react';
import { AppState, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import type { DayItemStatus, TodayRoutineRow } from '../../domain/models';
import { addLocalDays, dateKey, localDayFromKey, startOfLocalDay } from '../../logic/calendar';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { StaggerFadeIn } from '../../ui/motion/stagger-fade-in';
import { theme } from '../../ui/theme';
import { TodayDateBar } from './today-date-bar';
import { TodayItem } from './today-item';
import { TodayWeeklyGoalsCard } from './today-weekly-goals-card';

export function TodayScreen({
  focusDayKey,
  onFocusDayHandled,
  onCloseDay,
  onAssistant,
  onWeek,
}: {
  focusDayKey?: string | null;
  onFocusDayHandled?: () => void;
  onCloseDay: (dayKey: string) => void;
  onAssistant: (dayKey: string) => void;
  onWeek?: () => void;
}) {
  const { routine, reports } = useRepos();
  const { syncRevision } = useSync();
  const [rows, setRows] = useState<TodayRoutineRow[]>([]);
  const [selectedDate, setSelectedDate] = useState(() => startOfLocalDay(new Date()));
  const [calendarTodayKey, setCalendarTodayKey] = useState(() => dateKey(new Date()));
  const [dayClosed, setDayClosed] = useState(false);

  const selectedKey = dateKey(selectedDate);
  const isViewingToday = selectedKey === calendarTodayKey;

  const reload = useCallback(async () => {
    setRows(await routine.loadTodayRows(selectedDate));
    const rep = await reports.getDaily(selectedKey);
    setDayClosed(rep != null);
  }, [routine, reports, selectedDate, selectedKey]);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

  useEffect(() => {
    if (!focusDayKey) return;
    try {
      setSelectedDate(startOfLocalDay(localDayFromKey(focusDayKey)));
    } catch {
      /* ignore invalid */
    }
    onFocusDayHandled?.();
  }, [focusDayKey, onFocusDayHandled]);

  useEffect(() => {
    const syncCalendarDay = () => {
      const now = startOfLocalDay(new Date());
      const nowKey = dateKey(now);
      setCalendarTodayKey((prevKey) => {
        if (nowKey !== prevKey) {
          setSelectedDate((sel) => (dateKey(sel) === prevKey ? now : sel));
        }
        return nowKey;
      });
    };

    const sub = AppState.addEventListener('change', (state) => {
      if (state === 'active') {
        syncCalendarDay();
      }
    });
    return () => sub.remove();
  }, []);

  const setStatus = async (routineItemId: string, status: DayItemStatus) => {
    await routine.setDayStatus(selectedDate, routineItemId, status);
    await reload();
  };

  return (
    <View style={styles.root}>
      <ScrollView style={styles.wrap} contentContainerStyle={styles.content}>
      <StaggerFadeIn index={0}>
        <TodayDateBar
          date={selectedDate}
          isToday={isViewingToday}
          onPrev={() => setSelectedDate((d) => addLocalDays(d, -1))}
          onNext={() => setSelectedDate((d) => addLocalDays(d, 1))}
          onJumpToday={() => setSelectedDate(startOfLocalDay(new Date()))}
        />
      </StaggerFadeIn>
      <StaggerFadeIn index={1}>
        <Text style={styles.title}>{isViewingToday ? 'Today' : 'Day'}</Text>
      </StaggerFadeIn>
      {isViewingToday ? (
        <StaggerFadeIn index={2}>
          <TodayWeeklyGoalsCard date={selectedDate} onWeek={onWeek} onChanged={() => void reload()} />
        </StaggerFadeIn>
      ) : null}
      {rows.length === 0 ? (
        <StaggerFadeIn index={3}>
          <Text style={styles.empty}>
            No routine items for this weekday yet. Add them on the Routine tab.
          </Text>
        </StaggerFadeIn>
      ) : (
        rows.map((row, index) => (
          <StaggerFadeIn key={row.item.id} index={index + 3}>
            <TodayItem
              row={row}
              onStatus={(id, status) => void setStatus(id, status)}
            />
          </StaggerFadeIn>
        ))
      )}
      <StaggerFadeIn index={rows.length + 4}>
        <AnimatedPressable
          style={[styles.cta, dayClosed && styles.ctaDisabled]}
          onPress={() => !dayClosed && onCloseDay(selectedKey)}
          disabled={dayClosed}
        >
          <Text style={styles.ctaText}>{dayClosed ? 'Day closed' : 'Close day'}</Text>
        </AnimatedPressable>
      </StaggerFadeIn>
      </ScrollView>
      <AnimatedPressable style={styles.fab} onPress={() => onAssistant(selectedKey)} accessibilityLabel="Open assistant">
        <Text style={styles.fabText}>✦</Text>
      </AnimatedPressable>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  wrap: { flex: 1, backgroundColor: 'transparent' },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  title: {
    fontSize: 32,
    fontWeight: '700',
    marginBottom: theme.spacing.section,
    color: theme.colors.text,
  },
  empty: { color: theme.colors.textMuted },
  cta: {
    marginTop: 24,
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  ctaDisabled: { opacity: 0.45 },
  ctaText: { color: theme.colors.accentOn, fontWeight: '700', fontSize: 16 },
  fab: {
    position: 'absolute',
    right: theme.spacing.screenX,
    bottom: 16,
    width: 52,
    height: 52,
    borderRadius: 26,
    backgroundColor: theme.colors.accent,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 4,
  },
  fabText: { color: theme.colors.accentOn, fontSize: 22, fontWeight: '700' },
});

import { useCallback, useEffect, useState } from 'react';
import { AppState, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import type { DayItemStatus, TodayRoutineRow } from '../../domain/models';
import { addLocalDays, dateKey, startOfLocalDay } from '../../logic/calendar';
import { theme } from '../../ui/theme';
import { TodayDateBar } from './today-date-bar';
import { TodayItem } from './today-item';

export function TodayScreen({
  onCloseDay,
  onAssistant,
}: {
  onCloseDay: () => void;
  onAssistant: () => void;
}) {
  const { routine } = useRepos();
  const { syncRevision } = useSync();
  const [rows, setRows] = useState<TodayRoutineRow[]>([]);
  const [selectedDate, setSelectedDate] = useState(() => startOfLocalDay(new Date()));
  const [calendarTodayKey, setCalendarTodayKey] = useState(() => dateKey(new Date()));

  const selectedKey = dateKey(selectedDate);
  const isViewingToday = selectedKey === calendarTodayKey;

  const reload = useCallback(async () => {
    setRows(await routine.loadTodayRows(selectedDate));
  }, [routine, selectedDate]);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

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
      <TodayDateBar
        date={selectedDate}
        isToday={isViewingToday}
        onPrev={() => setSelectedDate((d) => addLocalDays(d, -1))}
        onNext={() => setSelectedDate((d) => addLocalDays(d, 1))}
        onJumpToday={() => setSelectedDate(startOfLocalDay(new Date()))}
      />
      <Text style={styles.title}>{isViewingToday ? 'Today' : 'Day'}</Text>
      {rows.length === 0 ? (
        <Text style={styles.empty}>
          No routine items for this weekday yet. Add them on the Routine tab.
        </Text>
      ) : (
        rows.map((row) => (
          <TodayItem
            key={row.item.id}
            row={row}
            onStatus={(id, status) => void setStatus(id, status)}
          />
        ))
      )}
      <Pressable style={styles.cta} onPress={onCloseDay}>
        <Text style={styles.ctaText}>Close day</Text>
      </Pressable>
      </ScrollView>
      <Pressable style={styles.fab} onPress={onAssistant} accessibilityLabel="Open assistant">
        <Text style={styles.fabText}>✦</Text>
      </Pressable>
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

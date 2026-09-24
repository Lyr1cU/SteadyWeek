import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Ionicons } from '@expo/vector-icons';
import { ScrollView, StyleSheet, Text } from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import { addLocalDays, dayKeysForWeek, localDayFromKey } from '../../logic/calendar';
import { computeWeeklyReportSummary } from '../../logic/weekly-report-summary';
import { strings } from '../../l10n';
import { AppBackground } from '../../ui/app-background';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { StaggerFadeIn } from '../../ui/motion/stagger-fade-in';
import { theme } from '../../ui/theme';
import { useKeyboardBottomInset } from '../../ui/use-keyboard-inset';
import { WeeklyReportNotesCard } from './weekly-report-notes-card';
import { WeeklyReportSummaryCard } from './weekly-report-summary-card';

function formatWeekRange(weekKey: string): string {
  const mon = localDayFromKey(weekKey);
  const sun = addLocalDays(mon, 6);
  const monStr = mon.toLocaleDateString(undefined, {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
  });
  const sunStr = sun.toLocaleDateString(undefined, {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
  return `${monStr} – ${sunStr}`;
}

export function WeeklyReportScreen({
  weekKey,
  onBack,
}: {
  weekKey: string;
  onBack: () => void;
}) {
  const { goals, reports } = useRepos();
  const { syncRevision } = useSync();
  const dayKeys = useMemo(() => dayKeysForWeek(weekKey), [weekKey]);
  const [noteWin, setNoteWin] = useState('');
  const [noteFocus, setNoteFocus] = useState('');
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const keyboardInset = useKeyboardBottomInset();
  const scrollRef = useRef<ScrollView>(null);
  const copy = strings().weeklyReport;
  const common = strings().common;

  const scrollFormIntoView = useCallback(() => {
    requestAnimationFrame(() => {
      scrollRef.current?.scrollToEnd({ animated: true });
    });
  }, []);

  const [summary, setSummary] = useState(() =>
    computeWeeklyReportSummary({
      dayKeysInOrder: dayKeys,
      reportsInWeek: [],
      goalsForWeek: [],
    }),
  );

  const reload = useCallback(async () => {
    const [goalList, daily] = await Promise.all([
      goals.listForWeek(weekKey),
      reports.listDailyInWeek(weekKey, dayKeys),
    ]);
    setSummary(
      computeWeeklyReportSummary({
        dayKeysInOrder: dayKeys,
        reportsInWeek: daily,
        goalsForWeek: goalList,
      }),
    );
    const notes = await reports.getWeekly(weekKey);
    if (notes) {
      setNoteWin(notes.noteWin);
      setNoteFocus(notes.noteFocus);
    }
  }, [goals, reports, weekKey, dayKeys]);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

  const save = async () => {
    setSaving(true);
    setSaved(false);
    try {
      await reports.saveWeeklyNotes(weekKey, noteWin, noteFocus);
      setSaved(true);
    } finally {
      setSaving(false);
    }
  };

  return (
    <AppBackground>
      <ScrollView
        ref={scrollRef}
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={[
          styles.content,
          keyboardInset > 0 && { paddingBottom: keyboardInset + 24 },
        ]}
      >
        <StaggerFadeIn index={0}>
          <AnimatedPressable onPress={onBack} style={styles.back}>
            <Ionicons name="chevron-back" size={22} color={theme.colors.accent} />
            <Text style={styles.backText}>{common.back}</Text>
          </AnimatedPressable>
          <Text style={styles.title}>{copy.title}</Text>
          <Text style={styles.weekLine}>{copy.weekOf(formatWeekRange(weekKey))}</Text>
          <Text style={styles.subtitle}>{copy.subtitle}</Text>
        </StaggerFadeIn>

        <StaggerFadeIn index={1}>
          <WeeklyReportSummaryCard summary={summary} />
        </StaggerFadeIn>

        <StaggerFadeIn index={2}>
        <WeeklyReportNotesCard
          noteWin={noteWin}
          noteFocus={noteFocus}
          saving={saving}
          saved={saved}
          onWin={setNoteWin}
          onFocus={setNoteFocus}
          onSave={() => void save()}
          onFocusField={scrollFormIntoView}
        />
        </StaggerFadeIn>
      </ScrollView>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  back: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 2,
    marginBottom: 12,
    alignSelf: 'flex-start',
  },
  backText: { color: theme.colors.accent, fontWeight: '600', fontSize: 16 },
  pressed: { opacity: 0.88 },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  weekLine: { marginTop: 4, color: theme.colors.text, fontSize: 16, fontWeight: '600' },
  subtitle: { color: theme.colors.textMuted, marginTop: 4, marginBottom: 16, lineHeight: 20 },
});

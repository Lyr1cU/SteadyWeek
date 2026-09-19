import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { useRepos } from '../../app/repos-context';
import { useSync } from '../../app/sync-context';
import { dayKeysForWeek } from '../../logic/calendar';
import { computeWeeklyReportSummary } from '../../logic/weekly-report-summary';
import { AppBackground } from '../../ui/app-background';
import { theme } from '../../ui/theme';
import { useKeyboardBottomInset } from '../../ui/use-keyboard-inset';

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
      <KeyboardAvoidingView
        style={styles.flex}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        keyboardVerticalOffset={Platform.OS === 'ios' ? 4 : 0}
      >
        <ScrollView
          ref={scrollRef}
          keyboardShouldPersistTaps="handled"
          contentContainerStyle={[styles.content, { paddingBottom: 48 + keyboardInset }]}
        >
        <Pressable onPress={onBack} style={styles.back}>
          <Text style={styles.backText}>← Back</Text>
        </Pressable>
        <Text style={styles.title}>Weekly report</Text>
        <Text style={styles.subtitle}>Week of {weekKey}</Text>

        <View style={styles.stats}>
          <Text style={styles.statsHeading}>This week</Text>
          <Text style={styles.statLine}>
            Days closed: {summary.daysClosed} / {summary.daysInWeek}
          </Text>
          <Text style={styles.statLine}>
            Green {summary.greenDays} · Yellow {summary.yellowDays} · Red {summary.redDays}
          </Text>
          <Text style={styles.statLine}>XP earned: {summary.weekXp}</Text>
          <Text style={styles.statLine}>
            Goals: {summary.goalsCompleted} / {summary.goalsTotal} completed
          </Text>
        </View>

        <Text style={styles.label}>Win of the week</Text>
        <TextInput
          style={styles.input}
          multiline
          value={noteWin}
          onChangeText={setNoteWin}
          onFocus={scrollFormIntoView}
          placeholder="What went well?"
          placeholderTextColor={theme.colors.textSubtle}
          maxLength={4000}
        />
        <Text style={styles.label}>Focus next week</Text>
        <TextInput
          style={styles.input}
          multiline
          value={noteFocus}
          onChangeText={setNoteFocus}
          onFocus={scrollFormIntoView}
          placeholder="One thing to improve"
          placeholderTextColor={theme.colors.textSubtle}
          maxLength={4000}
        />

        {saved ? <Text style={styles.saved}>Saved</Text> : null}
        <Pressable style={styles.cta} onPress={() => void save()} disabled={saving}>
          <Text style={styles.ctaText}>{saving ? 'Saving…' : 'Save notes'}</Text>
        </Pressable>
        </ScrollView>
      </KeyboardAvoidingView>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1 },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  back: { marginBottom: 12 },
  backText: { color: theme.colors.accent, fontWeight: '600' },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  subtitle: { color: theme.colors.textMuted, marginBottom: 20 },
  stats: {
    backgroundColor: theme.colors.surfaceHigh,
    padding: 14,
    borderRadius: theme.radius.lg,
    marginBottom: 20,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  statsHeading: { fontWeight: '700', color: theme.colors.text, marginBottom: 8 },
  statLine: { color: theme.colors.textMuted, marginBottom: 4 },
  label: { color: theme.colors.textMuted, marginBottom: 6, marginTop: 8 },
  input: {
    backgroundColor: theme.colors.surfaceHigh,
    borderRadius: theme.radius.md,
    padding: 12,
    minHeight: 80,
    color: theme.colors.text,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
    textAlignVertical: 'top',
  },
  saved: { color: theme.colors.accent, marginTop: 10, fontWeight: '600' },
  cta: {
    marginTop: 20,
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  ctaText: { color: theme.colors.accentOn, fontWeight: '700', fontSize: 16 },
});

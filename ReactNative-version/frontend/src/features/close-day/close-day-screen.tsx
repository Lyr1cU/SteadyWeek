import { useEffect, useState } from 'react';
import { Ionicons } from '@expo/vector-icons';
import { ScrollView, StyleSheet, Text } from 'react-native';
import { useRepos } from '../../app/repos-context';
import {
  DayAlreadyClosedError,
  FutureDayCloseError,
  type CloseDayOutcome,
} from '../../data/day-closure-service';
import { dateKey, localDayFromKey } from '../../logic/calendar';
import { streakWarnThreshold } from '../../logic/streak-warning-config';
import {
  countWarningsInWindow,
  warningPointsForReport,
  warningWindowDayKeys,
} from '../../logic/warnings';
import { assistantAfterCloseDay } from '../../logic/assistant-close-day';
import { strings } from '../../l10n';
import { AppBackground } from '../../ui/app-background';
import { GlassSurface } from '../../ui/glass-surface';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { StaggerFadeIn } from '../../ui/motion/stagger-fade-in';
import { theme } from '../../ui/theme';
import { useKeyboardBottomInset } from '../../ui/use-keyboard-inset';
import { CloseDayFormCard } from './close-day-form-card';
import { CloseDayResultCard } from './close-day-result-card';

function formatDayLabel(dayKey: string): string {
  const d = localDayFromKey(dayKey);
  return d.toLocaleDateString(undefined, {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

export function CloseDayScreen({
  dayKey,
  onBack,
}: {
  dayKey: string;
  onBack: () => void;
}) {
  const { dayClosure, reports } = useRepos();
  const [highlight, setHighlight] = useState('');
  const [reflection, setReflection] = useState('');
  const [mood, setMood] = useState<number | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [outcome, setOutcome] = useState<CloseDayOutcome | null>(null);
  const [postCloseWarnCount, setPostCloseWarnCount] = useState<number | null>(null);
  const [addedWarningPoint, setAddedWarningPoint] = useState(false);
  const [alreadyClosed, setAlreadyClosed] = useState(false);
  const keyboardInset = useKeyboardBottomInset();

  const copy = strings().closeDay;
  const common = strings().common;

  useEffect(() => {
    void reports.getDaily(dayKey).then((r) => {
      if (r) setAlreadyClosed(true);
    });
  }, [reports, dayKey]);

  const submit = async () => {
    setError(null);
    setSubmitting(true);
    try {
      const date = localDayFromKey(dayKey);
      const result = await dayClosure.submit({
        date,
        noteHighlight: highlight,
        noteReflection: reflection,
        mood,
      });
      setOutcome(result);
      const anchor = dateKey(new Date());
      const { startKey, endKey } = warningWindowDayKeys(anchor);
      const windowReports = await reports.listDailyInDayKeyRange(startKey, endKey);
      const merged = [
        ...windowReports.filter((r) => r.dayKey !== result.report.dayKey),
        result.report,
      ];
      setPostCloseWarnCount(countWarningsInWindow(merged, anchor));
      const inWindow =
        result.report.dayKey >= startKey && result.report.dayKey <= endKey;
      setAddedWarningPoint(inWindow && warningPointsForReport(result.report) === 1);
    } catch (e) {
      if (e instanceof DayAlreadyClosedError) {
        setAlreadyClosed(true);
        setError(copy.errorAlreadyClosed);
      } else if (e instanceof FutureDayCloseError) {
        setError(copy.errorFuture);
      } else {
        setError(e instanceof Error ? e.message : copy.errorGeneric);
      }
    } finally {
      setSubmitting(false);
    }
  };

  const assistantLine = outcome
    ? assistantAfterCloseDay(outcome.tier, outcome.newStreak)
    : null;

  return (
    <AppBackground>
      <ScrollView
        contentContainerStyle={[
          styles.content,
          keyboardInset > 0 && { paddingBottom: keyboardInset + 24 },
        ]}
        keyboardShouldPersistTaps="handled"
      >
        <StaggerFadeIn index={0}>
          <AnimatedPressable onPress={onBack} style={styles.back}>
            <Ionicons name="chevron-back" size={22} color={theme.colors.accent} />
            <Text style={styles.backText}>{common.back}</Text>
          </AnimatedPressable>
          <Text style={styles.title}>{copy.title}</Text>
          <Text style={styles.dateLine}>{formatDayLabel(dayKey)}</Text>
          <Text style={styles.subtitle}>{copy.subtitle}</Text>
        </StaggerFadeIn>

        {alreadyClosed && !outcome ? (
          <StaggerFadeIn index={1}>
            <GlassSurface style={styles.closedBanner}>
              <Text style={styles.closedText}>{copy.alreadyClosed}</Text>
              <AnimatedPressable onPress={onBack} style={styles.closedBtn}>
                <Text style={styles.closedBtnText}>{common.back}</Text>
              </AnimatedPressable>
            </GlassSurface>
          </StaggerFadeIn>
        ) : null}

        {outcome ? (
          <StaggerFadeIn index={1}>
          <CloseDayResultCard
            outcome={outcome}
            assistantLine={assistantLine}
            addedWarningPoint={addedWarningPoint}
            postCloseWarnCount={postCloseWarnCount}
            onDone={onBack}
          />
          </StaggerFadeIn>
        ) : (
          <StaggerFadeIn index={1}>
          <CloseDayFormCard
            highlight={highlight}
            reflection={reflection}
            mood={mood}
            error={error}
            submitting={submitting}
            disabled={alreadyClosed}
            onHighlight={setHighlight}
            onReflection={setReflection}
            onMood={setMood}
            onSubmit={() => void submit()}
          />
          </StaggerFadeIn>
        )}
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
  dateLine: { marginTop: 4, color: theme.colors.text, fontSize: 16, fontWeight: '600' },
  subtitle: { color: theme.colors.textMuted, marginTop: 4, marginBottom: 16, lineHeight: 20 },
  closedBanner: {
    marginBottom: 16,
    padding: 16,
    borderRadius: theme.radius.lg,
  },
  closedText: { color: theme.colors.textMuted, lineHeight: 21 },
  closedBtn: { marginTop: 12, alignSelf: 'flex-start' },
  closedBtnText: { color: theme.colors.accent, fontWeight: '700', fontSize: 15 },
});

import { useEffect, useState } from 'react';
import {
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { useRepos } from '../../app/repos-context';
import {
  DayAlreadyClosedError,
  FutureDayCloseError,
  type CloseDayOutcome,
} from '../../data/day-closure-service';
import { localDayFromKey } from '../../logic/calendar';
import { assistantAfterCloseDay } from '../../logic/assistant-close-day';
import { AppBackground } from '../../ui/app-background';
import { theme } from '../../ui/theme';

const MOODS = [1, 2, 3, 4, 5] as const;

function tierLabel(tier: CloseDayOutcome['tier']): string {
  if (tier === 'green') return 'Green day';
  if (tier === 'yellow') return 'Yellow day';
  return 'Red day';
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
  const [alreadyClosed, setAlreadyClosed] = useState(false);

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
    } catch (e) {
      if (e instanceof DayAlreadyClosedError) {
        setAlreadyClosed(true);
        setError('This day is already closed.');
      } else if (e instanceof FutureDayCloseError) {
        setError('You can only close today or a past day.');
      } else {
        setError(e instanceof Error ? e.message : 'Could not close day');
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
      <ScrollView contentContainerStyle={styles.content}>
        <Pressable onPress={onBack} style={styles.back}>
          <Text style={styles.backText}>← Back</Text>
        </Pressable>
        <Text style={styles.title}>Close day</Text>
        <Text style={styles.subtitle}>{dayKey}</Text>

        {alreadyClosed && !outcome ? (
          <Text style={styles.info}>This day was already closed.</Text>
        ) : null}

        {outcome ? (
          <View style={styles.result}>
            <Text style={styles.resultTier}>{tierLabel(outcome.tier)}</Text>
            <Text style={styles.resultMeta}>
              +{outcome.xpAwarded} XP · streak {outcome.newStreak} · total {outcome.newTotalXp} XP
            </Text>
            {assistantLine ? <Text style={styles.assistant}>{assistantLine}</Text> : null}
            <Pressable style={styles.cta} onPress={onBack}>
              <Text style={styles.ctaText}>Done</Text>
            </Pressable>
          </View>
        ) : (
          <>
            <Text style={styles.label}>Highlight</Text>
            <TextInput
              style={styles.input}
              multiline
              value={highlight}
              onChangeText={setHighlight}
              placeholder="Best moment today?"
              placeholderTextColor={theme.colors.textSubtle}
              maxLength={2000}
            />
            <Text style={styles.label}>Reflection</Text>
            <TextInput
              style={styles.input}
              multiline
              value={reflection}
              onChangeText={setReflection}
              placeholder="What would you do differently?"
              placeholderTextColor={theme.colors.textSubtle}
              maxLength={4000}
            />
            <Text style={styles.label}>Mood (optional)</Text>
            <View style={styles.moodRow}>
              {MOODS.map((m) => (
                <Pressable
                  key={m}
                  onPress={() => setMood(mood === m ? null : m)}
                  style={[styles.moodChip, mood === m && styles.moodChipOn]}
                >
                  <Text style={[styles.moodText, mood === m && styles.moodTextOn]}>{m}</Text>
                </Pressable>
              ))}
            </View>
            {error ? <Text style={styles.error}>{error}</Text> : null}
            <Pressable
              style={[styles.cta, (submitting || alreadyClosed) && styles.ctaDisabled]}
              onPress={() => void submit()}
              disabled={submitting || alreadyClosed}
            >
              <Text style={styles.ctaText}>{submitting ? 'Saving…' : 'Close day'}</Text>
            </Pressable>
          </>
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
  back: { marginBottom: 12 },
  backText: { color: theme.colors.accent, fontWeight: '600' },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text },
  subtitle: { color: theme.colors.textMuted, marginBottom: 20 },
  label: { color: theme.colors.textMuted, marginBottom: 6, marginTop: 12 },
  input: {
    backgroundColor: theme.colors.surfaceHigh,
    borderRadius: theme.radius.md,
    padding: 12,
    minHeight: 72,
    color: theme.colors.text,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
    textAlignVertical: 'top',
  },
  moodRow: { flexDirection: 'row', gap: 8, marginTop: 4 },
  moodChip: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: theme.colors.surfaceHigh,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  moodChipOn: { backgroundColor: theme.colors.accentContainer, borderColor: theme.colors.accent },
  moodText: { color: theme.colors.textMuted, fontWeight: '700' },
  moodTextOn: { color: theme.colors.accent },
  cta: {
    marginTop: 24,
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  ctaDisabled: { opacity: 0.5 },
  ctaText: { color: theme.colors.accentOn, fontWeight: '700', fontSize: 16 },
  error: { color: '#f87171', marginTop: 12 },
  info: { color: theme.colors.textMuted, marginBottom: 12 },
  result: {
    backgroundColor: theme.colors.surfaceHigh,
    padding: 16,
    borderRadius: theme.radius.lg,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: theme.colors.border,
  },
  resultTier: { fontSize: 22, fontWeight: '700', color: theme.colors.text },
  resultMeta: { marginTop: 8, color: theme.colors.textMuted, lineHeight: 22 },
  assistant: { marginTop: 14, color: theme.colors.text, lineHeight: 22, fontStyle: 'italic' },
});

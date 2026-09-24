import { StyleSheet, Text, View } from 'react-native';
import type { CloseDayOutcome } from '../../data/day-closure-service';
import type { DayTier } from '../../domain/day-tier';
import { levelFromTotalXp } from '../../logic/economy';
import { streakWarnThreshold } from '../../logic/streak-warning-config';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { tierRimStyle } from '../../ui/day-tier-ui';
import { theme } from '../../ui/theme';

function tierTitle(tier: DayTier): string {
  const copy = strings().closeDay;
  if (tier === 'green') return copy.tierGreen;
  if (tier === 'yellow') return copy.tierYellow;
  return copy.tierRed;
}

export function CloseDayResultCard({
  outcome,
  assistantLine,
  addedWarningPoint,
  postCloseWarnCount,
  onDone,
}: {
  outcome: CloseDayOutcome;
  assistantLine: string | null;
  addedWarningPoint: boolean;
  postCloseWarnCount: number | null;
  onDone: () => void;
}) {
  const copy = strings().closeDay;
  const profileCopy = strings().profile;
  const rim = tierRimStyle(outcome.tier);
  const level = levelFromTotalXp(outcome.newTotalXp);

  return (
    <GlassSurface
      style={[
        styles.card,
        { borderWidth: 1.5, borderColor: rim.borderColor },
      ]}
    >
      <View style={[styles.inner, { backgroundColor: rim.backgroundColor }]}>
        <View style={styles.tierRow}>
          <Text style={[styles.tierDot, { color: rim.accent }]}>●</Text>
          <Text style={styles.tierTitle}>{tierTitle(outcome.tier)}</Text>
        </View>
        <Text style={styles.meta}>
          {copy.resultXp(outcome.xpAwarded)} · {copy.resultStreak(outcome.newStreak)} ·{' '}
          {profileCopy.xpTotal(outcome.newTotalXp)} · {profileCopy.level(level)}
        </Text>
        {addedWarningPoint && postCloseWarnCount != null ? (
          <View style={styles.warnBadge}>
            <Text style={styles.warnText}>
              {copy.warningCounted(postCloseWarnCount, streakWarnThreshold)}
            </Text>
          </View>
        ) : null}
        {assistantLine ? (
          <View style={styles.assistantBox}>
            <Text style={styles.assistant}>{assistantLine}</Text>
          </View>
        ) : null}
        <AnimatedPressable style={styles.cta} onPress={onDone}>
          <Text style={styles.ctaText}>{copy.done}</Text>
        </AnimatedPressable>
      </View>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: { borderRadius: theme.radius.lg, padding: 0 },
  inner: { padding: 16, borderRadius: theme.radius.lg - 2 },
  tierRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  tierDot: { fontSize: 14 },
  tierTitle: { fontSize: 22, fontWeight: '700', color: theme.colors.text },
  meta: { marginTop: 10, color: theme.colors.textMuted, lineHeight: 22, fontSize: 15 },
  warnBadge: {
    marginTop: 12,
    alignSelf: 'flex-start',
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(255, 193, 7, 0.12)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(255, 193, 7, 0.45)',
  },
  warnText: { fontSize: 12, fontWeight: '600', color: theme.colors.warningText },
  assistantBox: {
    marginTop: 14,
    padding: 12,
    borderRadius: theme.radius.md,
    backgroundColor: 'rgba(8, 7, 14, 0.25)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(202, 184, 255, 0.15)',
  },
  assistant: { color: theme.colors.text, lineHeight: 22, fontStyle: 'italic' },
  cta: {
    marginTop: 18,
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  pressed: { opacity: 0.88 },
  ctaText: { color: theme.colors.accentOn, fontWeight: '700', fontSize: 16 },
});

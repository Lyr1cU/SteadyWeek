import { StyleSheet, Text, View } from 'react-native';
import type { WeeklyReportSummary } from '../../logic/weekly-report-summary';
import { strings } from '../../l10n';
import { tierRimStyle } from '../../ui/day-tier-ui';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

function TierDot({ tier, count }: { tier: 'green' | 'yellow' | 'red'; count: number }) {
  const rim = tierRimStyle(tier);
  const copy = strings().week;
  const label =
    tier === 'green' ? copy.legendGreen : tier === 'yellow' ? copy.legendYellow : copy.legendRed;

  return (
    <View style={[styles.tierPill, { borderColor: rim.borderColor, backgroundColor: rim.backgroundColor }]}>
      <Text style={[styles.tierDot, { color: rim.accent }]}>●</Text>
      <Text style={styles.tierLabel}>
        {label} {count}
      </Text>
    </View>
  );
}

export function WeeklyReportSummaryCard({ summary }: { summary: WeeklyReportSummary }) {
  const copy = strings().weeklyReport;

  return (
    <GlassSurface style={styles.card}>
      <Text style={styles.heading}>{copy.thisWeek}</Text>
      <Text style={styles.line}>{copy.daysClosed(summary.daysClosed, summary.daysInWeek)}</Text>
      <View style={styles.tierRow}>
        <TierDot tier="green" count={summary.greenDays} />
        <TierDot tier="yellow" count={summary.yellowDays} />
        <TierDot tier="red" count={summary.redDays} />
      </View>
      <Text style={styles.line}>{copy.xpEarned(summary.weekXp)}</Text>
      <Text style={styles.line}>
        {copy.goalsCompleted(summary.goalsCompleted, summary.goalsTotal)}
      </Text>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: { marginBottom: 12, borderRadius: theme.radius.lg, padding: 16 },
  heading: { fontWeight: '700', color: theme.colors.text, marginBottom: 10, fontSize: 17 },
  line: { color: theme.colors.textMuted, marginBottom: 8, fontSize: 15 },
  tierRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginBottom: 10 },
  tierPill: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: theme.radius.pill,
    borderWidth: StyleSheet.hairlineWidth,
  },
  tierDot: { fontSize: 10 },
  tierLabel: { fontSize: 12, fontWeight: '600', color: theme.colors.textMuted },
});

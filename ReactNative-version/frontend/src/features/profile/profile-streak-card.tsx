import { Ionicons } from '@expo/vector-icons';
import { StyleSheet, Text, View } from 'react-native';
import { streakWarnThreshold } from '../../logic/streak-warning-config';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function ProfileStreakCard({
  currentStreak,
  bestStreak,
  lastGreenDayKey,
  warnCount,
}: {
  currentStreak: number;
  bestStreak: number;
  lastGreenDayKey: string | null;
  warnCount: number;
}) {
  const copy = strings().profile;
  const warnHot = warnCount >= streakWarnThreshold;

  return (
    <GlassSurface style={styles.card}>
      <View style={styles.headerRow}>
        <Ionicons name="flame" size={22} color={theme.colors.accent} />
        <Text style={styles.title}>{copy.streakFlame(currentStreak)}</Text>
      </View>
      <Text style={styles.hint}>{copy.streakHint}</Text>
      <Text style={styles.meta}>
        {copy.streakMeta(bestStreak, lastGreenDayKey)}
      </Text>
      <View style={[styles.warnBadge, warnHot && styles.warnBadgeHot]}>
        <Text style={[styles.warnText, warnHot && styles.warnTextHot]}>
          {copy.warnings(warnCount, streakWarnThreshold)}
        </Text>
      </View>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: { marginBottom: 10, borderRadius: theme.radius.lg, padding: 16 },
  headerRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  title: { fontSize: 18, fontWeight: '700', color: theme.colors.accent },
  hint: { marginTop: 6, color: theme.colors.textMuted, fontSize: 13, lineHeight: 18 },
  meta: { marginTop: 8, color: theme.colors.textSubtle, fontSize: 13, fontWeight: '600' },
  warnBadge: {
    marginTop: 12,
    alignSelf: 'flex-start',
    paddingHorizontal: 10,
    paddingVertical: 6,
    borderRadius: theme.radius.pill,
    backgroundColor: 'rgba(202, 184, 255, 0.1)',
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'rgba(202, 184, 255, 0.25)',
  },
  warnBadgeHot: {
    backgroundColor: 'rgba(255, 193, 7, 0.12)',
    borderColor: 'rgba(255, 193, 7, 0.45)',
  },
  warnText: { fontSize: 12, fontWeight: '600', color: theme.colors.textMuted },
  warnTextHot: { color: theme.colors.warningText },
});

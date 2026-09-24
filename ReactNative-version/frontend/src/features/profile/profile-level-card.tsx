import { StyleSheet, Text, View } from 'react-native';
import { levelFromTotalXp, xpProgressInLevel, xpToNextLevel } from '../../logic/economy';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function ProfileLevelCard({ totalXp }: { totalXp: number }) {
  const copy = strings().profile;
  const level = levelFromTotalXp(totalXp);
  const xpRemaining = xpToNextLevel(totalXp);
  const ratio = xpProgressInLevel(totalXp);

  return (
    <GlassSurface style={styles.card}>
      <Text style={styles.title}>{copy.level(level)}</Text>
      <Text style={styles.meta}>{copy.xpTotal(totalXp)}</Text>
      <View style={styles.track}>
        <View
          style={[
            styles.fill,
            { width: `${Math.round(ratio * 100)}%`, minWidth: ratio > 0 ? 4 : 0 },
          ]}
        />
      </View>
      {xpRemaining > 0 ? (
        <Text style={styles.hint}>{copy.xpToNextLevel(xpRemaining)}</Text>
      ) : null}
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: { marginBottom: 10, borderRadius: theme.radius.lg, padding: 16 },
  title: { fontSize: 22, fontWeight: '700', color: theme.colors.text },
  meta: { marginTop: 4, fontSize: 15, fontWeight: '600', color: theme.colors.textMuted },
  track: {
    marginTop: 12,
    height: 6,
    borderRadius: 3,
    backgroundColor: 'rgba(202, 184, 255, 0.12)',
    overflow: 'hidden',
  },
  fill: {
    height: '100%',
    borderRadius: 3,
    backgroundColor: theme.colors.accentMuted,
  },
  hint: { marginTop: 8, fontSize: 13, color: theme.colors.textSubtle },
});

import { Ionicons } from '@expo/vector-icons';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function WeekReportCta({ onPress }: { onPress: () => void }) {
  const copy = strings().week;

  return (
    <Pressable onPress={onPress} style={({ pressed }) => [pressed && styles.pressed]}>
      <GlassSurface style={styles.card}>
        <View style={styles.row}>
          <View style={styles.iconWrap}>
            <Ionicons name="bar-chart-outline" size={22} color={theme.colors.accent} />
          </View>
          <View style={styles.textCol}>
            <Text style={styles.title}>{copy.weeklyReport}</Text>
            <Text style={styles.hint}>{copy.weeklyReportHint}</Text>
          </View>
          <Ionicons name="chevron-forward" size={20} color={theme.colors.textSubtle} />
        </View>
      </GlassSurface>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  pressed: { opacity: 0.92 },
  card: { marginTop: theme.spacing.stack, borderRadius: theme.radius.lg },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    gap: 12,
  },
  iconWrap: {
    width: 40,
    height: 40,
    borderRadius: 12,
    backgroundColor: 'rgba(202, 184, 255, 0.12)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  textCol: { flex: 1, minWidth: 0 },
  title: { fontSize: 17, fontWeight: '700', color: theme.colors.text },
  hint: { marginTop: 4, fontSize: 13, color: theme.colors.textMuted, lineHeight: 18 },
});

import { Pressable, StyleSheet, Text, View } from 'react-native';
import { GlassSurface } from '../../ui/glass-surface';
import { theme } from '../../ui/theme';

export function TodayWeeklyGoalsCard({ onWeek }: { onWeek?: () => void }) {
  return (
    <GlassSurface style={styles.card}>
      <View style={styles.inner}>
      <Text style={styles.title}>Weekly goals</Text>
      <Text style={styles.body}>No goals for this week yet. Add them on the Week tab.</Text>
      {onWeek ? (
        <Pressable onPress={onWeek}>
          <Text style={styles.link}>Week</Text>
        </Pressable>
      ) : null}
      </View>
    </GlassSurface>
  );
}

const styles = StyleSheet.create({
  card: {
    marginBottom: theme.spacing.section,
    borderRadius: 16,
  },
  inner: {
    padding: 14,
  },
  title: {
    fontSize: 18,
    fontWeight: '700',
    color: theme.colors.text,
    marginBottom: 8,
  },
  body: {
    color: theme.colors.textMuted,
    lineHeight: 20,
  },
  link: {
    marginTop: 10,
    color: theme.colors.accent,
    fontWeight: '600',
  },
});

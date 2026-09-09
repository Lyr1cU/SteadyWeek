import { Pressable, StyleSheet, Text, View } from 'react-native';
import { AppBackground } from '../../ui/app-background';
import { theme } from '../../ui/theme';

export function OnboardingScreen({ onDone }: { onDone: () => void }) {
  return (
    <AppBackground>
      <View style={styles.wrap}>
        <Text style={styles.kicker}>Welcome</Text>
        <Text style={styles.title}>Balance over a 100-item list</Text>
        <Text style={styles.sub}>
          A gentle weekly rhythm — not a guilt trip. Full onboarding wizard comes later.
        </Text>
        <Pressable style={styles.cta} onPress={onDone}>
          <Text style={styles.ctaText}>Continue</Text>
        </Pressable>
      </View>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  wrap: {
    flex: 1,
    padding: 28,
    justifyContent: 'center',
  },
  kicker: { color: theme.colors.textSubtle, marginBottom: 8, fontSize: 14 },
  title: { fontSize: 28, fontWeight: '700', color: theme.colors.text, marginBottom: 12 },
  sub: { fontSize: 16, color: theme.colors.textMuted, lineHeight: 22, marginBottom: 28 },
  cta: {
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  ctaText: { color: theme.colors.accentOn, fontWeight: '700', fontSize: 16 },
});

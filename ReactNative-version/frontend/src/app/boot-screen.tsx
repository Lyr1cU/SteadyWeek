import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { theme } from '../ui/theme';

export function BootScreen({
  error,
}: {
  error?: string | null;
}) {
  return (
    <View style={styles.boot}>
      {error ? (
        <>
          <Text style={styles.bootTitle}>Could not start</Text>
          <Text style={styles.bootText}>{error}</Text>
        </>
      ) : (
        <>
          <ActivityIndicator size="large" color={theme.colors.accent} />
          <Text style={styles.bootText}>Loading local data…</Text>
        </>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  boot: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: theme.colors.background,
    padding: 24,
    gap: 12,
  },
  bootTitle: { fontSize: 20, fontWeight: '700', color: theme.colors.text },
  bootText: { color: theme.colors.textMuted, textAlign: 'center' },
});

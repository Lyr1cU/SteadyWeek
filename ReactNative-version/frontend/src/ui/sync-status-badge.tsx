import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useSync } from '../app/sync-context';
import { strings } from '../l10n';
import { theme } from './theme';

type SyncStatusLabel = 'offline' | 'syncing' | 'synced' | 'error';

const copy = strings().sync;

const labels: Record<SyncStatusLabel, string> = {
  offline: copy.offline,
  syncing: copy.syncing,
  synced: copy.synced,
  error: copy.error,
};

const dotColors: Record<SyncStatusLabel, string> = {
  offline: theme.colors.textSubtle,
  syncing: theme.colors.warning,
  synced: theme.colors.success,
  error: theme.colors.danger,
};

export function SyncStatusBadge() {
  const { status, syncError, triggerSync, loggedIn } = useSync();

  if (!loggedIn) {
    return null;
  }

  const label =
    status === 'error' && syncError ? syncError : labels[status];

  return (
    <Pressable onPress={() => void triggerSync()} style={styles.badge}>
      <View style={[styles.dot, { backgroundColor: dotColors[status] }]} />
      <Text style={styles.text}>{label}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  badge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    alignSelf: 'center',
    paddingVertical: 4,
    paddingHorizontal: 10,
    marginBottom: 0,
    zIndex: 11,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    shadowColor: theme.colors.success,
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.65,
    shadowRadius: 5,
  },
  text: { color: theme.colors.textMuted, fontSize: 14, fontWeight: '600', letterSpacing: 0.3 },
});

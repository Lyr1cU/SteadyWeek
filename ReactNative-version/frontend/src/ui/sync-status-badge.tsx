import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useSync } from '../app/sync-context';
import { theme } from './theme';

const labels: Record<SyncStatusLabel, string> = {
  offline: 'Offline',
  syncing: 'Syncing…',
  synced: 'Synced',
  error: 'Sync error',
};

type SyncStatusLabel = 'offline' | 'syncing' | 'synced' | 'error';

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
    paddingVertical: 6,
    paddingHorizontal: 10,
    marginBottom: 4,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  text: { color: theme.colors.textMuted, fontSize: 12, fontWeight: '600' },
});

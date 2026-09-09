import { useCallback, useEffect, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, Text } from 'react-native';
import { useSync } from '../../app/sync-context';
import { useRepos } from '../../app/repos-context';
import { clearAuthSession, getUserEmail } from '../../data/auth/auth-store';
import type { UserStats } from '../../domain/models';
import { theme } from '../../ui/theme';

export function ProfileScreen({
  onShop,
  onAssistant,
  onAuth,
}: {
  onShop: () => void;
  onAssistant: () => void;
  onAuth: () => void;
}) {
  const { stats } = useRepos();
  const { loggedIn, refreshAuth, triggerSync } = useSync();
  const [userStats, setUserStats] = useState<UserStats | null>(null);
  const [email, setEmail] = useState<string | null>(null);

  const reload = useCallback(async () => {
    setUserStats(await stats.get());
    setEmail(await getUserEmail());
  }, [stats]);

  useEffect(() => {
    void reload();
  }, [reload]);

  const signOut = async () => {
    await clearAuthSession();
    await refreshAuth();
  };

  return (
    <ScrollView style={styles.wrap} contentContainerStyle={styles.content}>
      <Text style={styles.title}>Profile</Text>
      <Text style={styles.subtitle}>
        XP, streak, and cosmetics. Shop and assistant stay extra routes until phase 5.
      </Text>
      {loggedIn && email ? (
        <Text style={styles.stat}>Signed in as {email}</Text>
      ) : (
        <Text style={styles.stat}>Local only — sign in to sync</Text>
      )}
      <Text style={styles.stat}>XP {userStats?.totalXp ?? 0}</Text>
      <Text style={styles.stat}>Streak {userStats?.currentStreak ?? 0}</Text>
      <Text style={styles.stat}>Best {userStats?.bestStreak ?? 0}</Text>
      <Pressable style={styles.link} onPress={onShop}>
        <Text style={styles.linkText}>Shop</Text>
      </Pressable>
      <Pressable style={styles.link} onPress={onAssistant}>
        <Text style={styles.linkText}>Assistant</Text>
      </Pressable>
      {loggedIn ? (
        <>
          <Pressable style={styles.link} onPress={() => void triggerSync()}>
            <Text style={styles.linkText}>Sync now</Text>
          </Pressable>
          <Pressable style={styles.link} onPress={() => void signOut()}>
            <Text style={styles.linkText}>Sign out</Text>
          </Pressable>
        </>
      ) : (
        <Pressable style={styles.link} onPress={onAuth}>
          <Text style={styles.linkText}>Sign in</Text>
        </Pressable>
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1, backgroundColor: 'transparent' },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text, marginBottom: 8 },
  subtitle: { color: theme.colors.textMuted, marginBottom: 20 },
  stat: { color: theme.colors.text, fontSize: 16, fontWeight: '600', marginBottom: 8 },
  link: { marginTop: 12 },
  linkText: { color: theme.colors.accent, fontWeight: '600', fontSize: 16 },
});

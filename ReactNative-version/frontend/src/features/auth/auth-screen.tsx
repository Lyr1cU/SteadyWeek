import { useState } from 'react';
import {
  ActivityIndicator,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';
import { loginUser, registerUser } from '../../data/api/client';
import { saveAuthSession } from '../../data/auth/auth-store';
import { getDatabase } from '../../data/sqlite/database';
import { getSyncedUserId, setSyncedUserId, wipeLocalSchedule } from '../../data/sqlite/sync-meta';
import { AppBackground } from '../../ui/app-background';
import { theme } from '../../ui/theme';
import { useSync } from '../../app/sync-context';

export function AuthScreen({
  onBack,
  onSignedIn,
}: {
  onBack: () => void;
  onSignedIn: () => void;
}) {
  const { triggerSync, refreshAuth } = useSync();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const submit = async (mode: 'login' | 'register') => {
    setError(null);
    setBusy(true);
    try {
      const result =
        mode === 'login'
          ? await loginUser(email.trim(), password)
          : await registerUser(email.trim(), password);

      await saveAuthSession(result.accessToken, result.user.email, result.user.id);
      const db = await getDatabase();
      const previousUserId = await getSyncedUserId(db);
      if (previousUserId && previousUserId !== result.user.id) {
        await wipeLocalSchedule(db);
      }
      await setSyncedUserId(db, result.user.id);
      await refreshAuth();
      await triggerSync();
      onSignedIn();
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Auth failed');
    } finally {
      setBusy(false);
    }
  };

  return (
    <AppBackground>
      <ScrollView style={styles.wrap} contentContainerStyle={styles.content}>
        <Pressable onPress={onBack} style={styles.back}>
          <Text style={styles.backText}>Back</Text>
        </Pressable>
        <Text style={styles.title}>Sign in</Text>
        <Text style={styles.subtitle}>
          Account syncs routine and day marks to Neon via Nest. Offline SQLite still works without
          login.
        </Text>

        <Text style={styles.label}>Email</Text>
        <TextInput
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
          keyboardType="email-address"
          style={styles.input}
          placeholder="you@example.com"
          placeholderTextColor={theme.colors.textSubtle}
        />

        <Text style={styles.label}>Password</Text>
        <TextInput
          value={password}
          onChangeText={setPassword}
          secureTextEntry
          style={styles.input}
          placeholder="min 8 characters"
          placeholderTextColor={theme.colors.textSubtle}
        />

        {error ? <Text style={styles.error}>{error}</Text> : null}

        <Pressable
          style={[styles.primaryBtn, busy && styles.btnDisabled]}
          disabled={busy}
          onPress={() => void submit('login')}
        >
          {busy ? (
            <ActivityIndicator color={theme.colors.accentOn} />
          ) : (
            <Text style={styles.primaryBtnText}>Log in</Text>
          )}
        </Pressable>

        <Pressable
          style={[styles.secondaryBtn, busy && styles.btnDisabled]}
          disabled={busy}
          onPress={() => void submit('register')}
        >
          <Text style={styles.secondaryBtnText}>Create account</Text>
        </Pressable>
      </ScrollView>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1 },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: 40,
  },
  back: { marginBottom: 16 },
  backText: { color: theme.colors.accent, fontWeight: '600', fontSize: 16 },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text, marginBottom: 8 },
  subtitle: { color: theme.colors.textMuted, marginBottom: 20, lineHeight: 22 },
  label: { marginTop: 10, marginBottom: 6, color: theme.colors.textMuted, fontWeight: '600' },
  input: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: theme.radius.sm,
    paddingHorizontal: 12,
    paddingVertical: 10,
    backgroundColor: theme.colors.surfaceHigh,
    color: theme.colors.text,
  },
  error: { marginTop: 12, color: theme.colors.danger },
  primaryBtn: {
    marginTop: 20,
    backgroundColor: theme.colors.accent,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
  },
  primaryBtnText: { color: theme.colors.accentOn, fontWeight: '700' },
  secondaryBtn: {
    marginTop: 10,
    paddingVertical: 14,
    borderRadius: theme.radius.md,
    alignItems: 'center',
    backgroundColor: theme.colors.surfaceHighest,
  },
  secondaryBtnText: { color: theme.colors.text, fontWeight: '600' },
  btnDisabled: { opacity: 0.6 },
});

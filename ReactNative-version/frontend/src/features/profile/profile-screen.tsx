import { useCallback, useEffect, useState } from 'react';
import { AppState, Platform, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useSync } from '../../app/sync-context';
import { useRepos } from '../../app/repos-context';
import { clearAuthSession, getUserEmail } from '../../data/auth/auth-store';
import type { UserStats } from '../../domain/models';
import { dateKey } from '../../logic/calendar';
import {
  countWarningsInWindow,
  shouldShowAssistantNudge,
  warningWindowDayKeys,
} from '../../logic/warnings';
import {
  canScheduleExactAlarms,
  canUseFullScreenIntent,
  openExactAlarmSettings,
  openFullScreenSettings,
} from '../../../modules/steadyweek-alarms';
import {
  closeDayRemindersAvailable,
  initCloseDayReminder,
  testCloseDayReminder,
} from '../../notifications/close-day-reminder';
import {
  getReminderPresentation,
  setReminderPresentation,
  type ReminderPresentation,
} from '../../notifications/reminder-presentation';
import { requestMissingAlarmAccess, syncRoutineReminders } from '../../notifications/routine-reminder-sync';
import { strings } from '../../l10n';
import { GlassSurface } from '../../ui/glass-surface';
import { ListSkeleton } from '../../ui/list-skeleton';
import { TAB_BAR_CLEARANCE } from '../../ui/motion/constants';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { useShellEnterKey } from '../../ui/motion/shell-pane';
import { StaggerFadeIn } from '../../ui/motion/stagger-fade-in';
import { theme } from '../../ui/theme';
import { ProfileInfoRow } from './profile-info-row';
import { ProfileLevelCard } from './profile-level-card';
import { ProfileMenuRow } from './profile-menu-row';
import { ProfileNudgeCard } from './profile-nudge-card';
import { ProfileStreakCard } from './profile-streak-card';

export function ProfileScreen({
  onShop,
  onAssistant,
  onAuth,
}: {
  onShop: () => void;
  onAssistant: () => void;
  onAuth: () => void;
}) {
  const enterKey = useShellEnterKey();
  const { stats, reports, routine } = useRepos();
  const { loggedIn, refreshAuth, triggerSync, syncRevision } = useSync();
  const [userStats, setUserStats] = useState<UserStats | null>(null);
  const [warnCount, setWarnCount] = useState(0);
  const [email, setEmail] = useState<string | null>(null);
  const [reminderMode, setReminderMode] = useState<ReminderPresentation>('shade');
  const [exactAlarms, setExactAlarms] = useState(true);
  const [fullScreenAllowed, setFullScreenAllowed] = useState(true);

  const reload = useCallback(async () => {
    const anchor = dateKey(new Date());
    const { startKey, endKey } = warningWindowDayKeys(anchor);
    const [s, windowReports] = await Promise.all([
      stats.get(),
      reports.listDailyInDayKeyRange(startKey, endKey),
    ]);
    setUserStats(s);
    setWarnCount(countWarningsInWindow(windowReports, anchor));
    setEmail(await getUserEmail());
  }, [stats, reports]);

  const refreshReminderAccess = useCallback(async () => {
    setReminderMode(await getReminderPresentation());
    setExactAlarms(canScheduleExactAlarms());
    setFullScreenAllowed(canUseFullScreenIntent());
  }, []);

  useEffect(() => {
    void reload();
  }, [reload, syncRevision]);

  useEffect(() => {
    void refreshReminderAccess();
    const sub = AppState.addEventListener('change', (state) => {
      if (state === 'active') {
        void refreshReminderAccess();
      }
    });
    return () => sub.remove();
  }, [refreshReminderAccess]);

  const chooseReminderMode = async (next: ReminderPresentation) => {
    if (next === reminderMode) {
      return;
    }
    await setReminderPresentation(next);
    setReminderMode(next);
    await requestMissingAlarmAccess(next, next === 'screen');
    const items = await routine.listTemplates();
    await syncRoutineReminders(items);
    await initCloseDayReminder();
    setExactAlarms(canScheduleExactAlarms());
    setFullScreenAllowed(canUseFullScreenIntent());
  };

  const signOut = async () => {
    await clearAuthSession();
    await refreshAuth();
  };

  const copy = strings().profile;
  const totalXp = userStats?.totalXp ?? 0;
  const showNudge = shouldShowAssistantNudge(warnCount);
  const remindersOn = closeDayRemindersAvailable();

  const showBody = enterKey >= 0 && userStats != null;

  return showBody ? (
    <ScrollView key={enterKey} style={styles.wrap} contentContainerStyle={styles.content}>
      <StaggerFadeIn index={0}>
        <Text style={styles.title}>{copy.screenTitle}</Text>
        {loggedIn && email ? (
          <Text style={styles.email} numberOfLines={1} ellipsizeMode="middle">
            {copy.signedInAs(email)}
          </Text>
        ) : (
          <GlassSurface style={styles.guestHint}>
            <Text style={styles.guestText}>{copy.localOnly}</Text>
            <AnimatedPressable onPress={onAuth} style={styles.guestLink}>
              <Text style={styles.guestLinkText}>{copy.signIn}</Text>
            </AnimatedPressable>
          </GlassSurface>
        )}
      </StaggerFadeIn>

      <StaggerFadeIn index={1}>
        <ProfileLevelCard totalXp={totalXp} />
      </StaggerFadeIn>

      <StaggerFadeIn index={2}>
        <ProfileStreakCard
          currentStreak={userStats?.currentStreak ?? 0}
          bestStreak={userStats?.bestStreak ?? 0}
          lastGreenDayKey={userStats?.lastGreenDayKey ?? null}
          warnCount={warnCount}
        />
      </StaggerFadeIn>

      {showNudge ? (
        <StaggerFadeIn index={3}>
          <ProfileNudgeCard onAssistant={onAssistant} />
        </StaggerFadeIn>
      ) : null}

      <StaggerFadeIn index={4}>
        <Text style={styles.sectionTitle}>{copy.sectionSettings}</Text>
      </StaggerFadeIn>
      <StaggerFadeIn index={5}>
      <GlassSurface style={styles.menuCard}>
        {remindersOn ? (
          <>
            {Platform.OS === 'android' ? (
              <>
                <ProfileMenuRow
                  icon="notifications-outline"
                  label={copy.reminderModeShade}
                  subtitle={copy.reminderModeShadeHint}
                  selected={reminderMode === 'shade'}
                  onPress={() => void chooseReminderMode('shade')}
                />
                <ProfileMenuRow
                  icon="phone-portrait-outline"
                  label={copy.reminderModeScreen}
                  subtitle={copy.reminderModeScreenHint}
                  selected={reminderMode === 'screen'}
                  onPress={() => void chooseReminderMode('screen')}
                />
                {!exactAlarms ? (
                  <ProfileMenuRow
                    icon="alarm-outline"
                    label={copy.exactAlarmsNeeded}
                    subtitle={copy.exactAlarmsNeededHint}
                    onPress={openExactAlarmSettings}
                  />
                ) : null}
                {reminderMode === 'screen' && !fullScreenAllowed ? (
                  <ProfileMenuRow
                    icon="expand-outline"
                    label={copy.fullScreenNeeded}
                    subtitle={copy.fullScreenNeededHint}
                    onPress={openFullScreenSettings}
                  />
                ) : null}
              </>
            ) : (
              <ProfileInfoRow
                icon="notifications-outline"
                label={copy.closeDayReminder}
                subtitle={copy.reminderStatusOk}
              />
            )}
            <ProfileMenuRow
              icon="time-outline"
              label={copy.testNotification}
              onPress={() => void testCloseDayReminder()}
            />
          </>
        ) : null}
        <ProfileMenuRow icon="bag-outline" label={copy.shop} onPress={onShop} last={false} />
        <ProfileMenuRow icon="chatbubble-ellipses-outline" label={copy.assistant} onPress={onAssistant} last />
      </GlassSurface>
      </StaggerFadeIn>

      <StaggerFadeIn index={6}>
        <Text style={styles.sectionTitle}>{copy.sectionAccount}</Text>
      </StaggerFadeIn>
      <StaggerFadeIn index={7}>
      <GlassSurface style={styles.menuCard}>
        {loggedIn ? (
          <>
            <ProfileMenuRow
              icon="cloud-upload-outline"
              label={copy.syncNow}
              onPress={() => void triggerSync()}
            />
            <ProfileMenuRow
              icon="log-out-outline"
              label={copy.signOut}
              onPress={() => void signOut()}
              danger
              last
            />
          </>
        ) : (
          <ProfileMenuRow icon="log-in-outline" label={copy.signIn} onPress={onAuth} last />
        )}
      </GlassSurface>
      </StaggerFadeIn>
    </ScrollView>
  ) : (
    <View style={styles.content}>
      <ListSkeleton variant="routine" rows={5} />
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1, backgroundColor: 'transparent' },
  content: {
    padding: theme.spacing.screenX,
    paddingTop: theme.spacing.screenTop,
    paddingBottom: TAB_BAR_CLEARANCE,
  },
  title: { fontSize: 32, fontWeight: '700', color: theme.colors.text, marginBottom: 8 },
  email: { color: theme.colors.textMuted, marginBottom: 16, fontSize: 14 },
  guestHint: {
    marginBottom: 16,
    padding: 14,
    borderRadius: theme.radius.lg,
  },
  guestText: { color: theme.colors.textMuted, lineHeight: 20 },
  guestLink: { marginTop: 10, alignSelf: 'flex-start' },
  guestLinkText: { color: theme.colors.accent, fontWeight: '700', fontSize: 15 },
  sectionTitle: {
    marginTop: 8,
    marginBottom: 10,
    fontSize: 18,
    fontWeight: '700',
    color: theme.colors.text,
  },
  menuCard: { marginBottom: 10, borderRadius: theme.radius.lg, paddingHorizontal: 14, paddingVertical: 2 },
});

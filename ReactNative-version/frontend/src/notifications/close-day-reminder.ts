import { Platform } from 'react-native';
import { strings } from '../l10n';
import {
  closeDayRemindersAvailable,
  ensureAndroidChannel,
  ensureNotificationsReady,
  loadNotificationsModule,
  localNotificationsAvailable,
} from './local-notifications-core';
import { closeDayChannelId, routineChannelId } from './reminder-channels';
import { getReminderPresentation } from './reminder-presentation';

export { closeDayRemindersAvailable, localNotificationsAvailable };

const CLOSE_DAY_NOTIFICATION_ID = 'steadyweek-close-day';
const TEST_NOTIFICATION_ID = 'steadyweek-reminder-test';

export async function initCloseDayReminder(options?: { hour?: number; minute?: number }) {
  if (!localNotificationsAvailable()) {
    return;
  }

  const Notifications = await loadNotificationsModule();
  const granted = await ensureNotificationsReady(Notifications);
  if (!granted) {
    return;
  }

  const hour = options?.hour ?? 21;
  const minute = options?.minute ?? 0;
  const copy = strings().notifications;
  const presentation = await getReminderPresentation();
  const channelId = closeDayChannelId(presentation);
  const fullScreen = presentation === 'screen';

  await ensureAndroidChannel(
    Notifications,
    channelId,
    'Daily check-in',
    'Reminder to close your day',
    fullScreen ? Notifications.AndroidImportance.MAX : Notifications.AndroidImportance.HIGH,
  );

  await Notifications.cancelScheduledNotificationAsync(CLOSE_DAY_NOTIFICATION_ID);

  await Notifications.scheduleNotificationAsync({
    identifier: CLOSE_DAY_NOTIFICATION_ID,
    content: {
      title: copy.closeDayTitle,
      body: copy.closeDayBody,
      sound: true,
      priority: fullScreen
        ? Notifications.AndroidNotificationPriority.MAX
        : Notifications.AndroidNotificationPriority.HIGH,
      data: fullScreen ? { fullScreen: true } : undefined,
    },
    trigger: {
      type: Notifications.SchedulableTriggerInputTypes.DAILY,
      hour,
      minute,
      channelId: Platform.OS === 'android' ? channelId : undefined,
    },
  });
}

/** Fires in 8 seconds using the current shade or full-screen mode. Lock the phone to check it. */
export async function testCloseDayReminder(): Promise<'scheduled' | 'denied' | 'unavailable'> {
  if (!localNotificationsAvailable()) {
    return 'unavailable';
  }

  const copy = strings().notifications;
  const Notifications = await loadNotificationsModule();
  const granted = await ensureNotificationsReady(Notifications);
  if (!granted) {
    return 'denied';
  }

  const presentation = await getReminderPresentation();
  const channelId = routineChannelId(presentation);
  const fullScreen = presentation === 'screen';

  await ensureAndroidChannel(
    Notifications,
    channelId,
    fullScreen ? 'Routine alarms' : 'Routine reminders',
    fullScreen
      ? 'Turns the screen on at scheduled routine times'
      : 'Reminders at scheduled routine times',
    fullScreen ? Notifications.AndroidImportance.MAX : Notifications.AndroidImportance.HIGH,
  );

  await Notifications.cancelScheduledNotificationAsync(TEST_NOTIFICATION_ID);

  await Notifications.scheduleNotificationAsync({
    identifier: TEST_NOTIFICATION_ID,
    content: {
      title: copy.routineTitle,
      body: copy.testBody,
      sound: true,
      priority: fullScreen
        ? Notifications.AndroidNotificationPriority.MAX
        : Notifications.AndroidNotificationPriority.HIGH,
      data: fullScreen ? { fullScreen: true } : undefined,
    },
    trigger: {
      type: Notifications.SchedulableTriggerInputTypes.TIME_INTERVAL,
      seconds: 8,
      repeats: false,
      channelId: Platform.OS === 'android' ? channelId : undefined,
    },
  });

  return 'scheduled';
}

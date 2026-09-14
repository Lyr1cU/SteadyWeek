import Constants, { ExecutionEnvironment } from 'expo-constants';
import { Platform } from 'react-native';
import { strings } from '../l10n';

const CLOSE_DAY_NOTIFICATION_ID = 'steadyweek-close-day';
const TEST_NOTIFICATION_ID = 'steadyweek-close-day-test';

let handlerInstalled = false;

function isDevBuild(): boolean {
  if (Platform.OS === 'web') {
    return false;
  }
  return Constants.executionEnvironment !== ExecutionEnvironment.StoreClient;
}

/** Local notifications — dev / release builds only (not Expo Go on Android). */
export function closeDayRemindersAvailable(): boolean {
  return isDevBuild();
}

async function loadNotifications() {
  return import('expo-notifications');
}

async function ensureNotificationReady(Notifications: Awaited<ReturnType<typeof loadNotifications>>) {
  if (!handlerInstalled) {
    Notifications.setNotificationHandler({
      handleNotification: async () => ({
        shouldShowAlert: true,
        shouldPlaySound: false,
        shouldSetBadge: false,
        shouldShowBanner: true,
        shouldShowList: true,
      }),
    });
    handlerInstalled = true;
  }

  const { status: existing } = await Notifications.getPermissionsAsync();
  if (existing === 'granted') {
    return true;
  }
  const { status } = await Notifications.requestPermissionsAsync();
  return status === 'granted';
}

async function ensureAndroidCloseDayChannel(
  Notifications: Awaited<ReturnType<typeof loadNotifications>>,
) {
  if (Platform.OS !== 'android') {
    return;
  }
  await Notifications.setNotificationChannelAsync('close_day', {
    name: 'Daily check-in',
    importance: Notifications.AndroidImportance.HIGH,
  });
}

export async function initCloseDayReminder(options?: { hour?: number; minute?: number }) {
  if (!closeDayRemindersAvailable()) {
    return;
  }

  const Notifications = await loadNotifications();
  const granted = await ensureNotificationReady(Notifications);
  if (!granted) {
    return;
  }

  const hour = options?.hour ?? 21;
  const minute = options?.minute ?? 0;
  const copy = strings().notifications;

  await ensureAndroidCloseDayChannel(Notifications);

  await Notifications.cancelScheduledNotificationAsync(CLOSE_DAY_NOTIFICATION_ID);

  await Notifications.scheduleNotificationAsync({
    identifier: CLOSE_DAY_NOTIFICATION_ID,
    content: {
      title: copy.closeDayTitle,
      body: copy.closeDayBody,
    },
    trigger: {
      type: Notifications.SchedulableTriggerInputTypes.DAILY,
      hour,
      minute,
      channelId: Platform.OS === 'android' ? 'close_day' : undefined,
    },
  });
}

/** Dev build only: system notification in ~5 seconds. */
export async function testCloseDayReminder(): Promise<'scheduled' | 'denied' | 'unavailable'> {
  if (!closeDayRemindersAvailable()) {
    return 'unavailable';
  }

  const copy = strings().notifications;
  const Notifications = await loadNotifications();
  const granted = await ensureNotificationReady(Notifications);
  if (!granted) {
    return 'denied';
  }

  await ensureAndroidCloseDayChannel(Notifications);

  await Notifications.cancelScheduledNotificationAsync(TEST_NOTIFICATION_ID);

  await Notifications.scheduleNotificationAsync({
    identifier: TEST_NOTIFICATION_ID,
    content: {
      title: copy.closeDayTitle,
      body: copy.closeDayBody,
    },
    trigger: {
      type: Notifications.SchedulableTriggerInputTypes.TIME_INTERVAL,
      seconds: 5,
      repeats: false,
      channelId: Platform.OS === 'android' ? 'close_day' : undefined,
    },
  });

  return 'scheduled';
}

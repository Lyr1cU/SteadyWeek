import { Platform } from 'react-native';
import { requireNativeModule } from 'expo-modules-core';

type SteadyWeekAlarmsNative = {
  canScheduleExactAlarms(): boolean;
  canUseFullScreenIntent(): boolean;
  openExactAlarmSettings(): void;
  openFullScreenSettings(): void;
};

function nativeModule(): SteadyWeekAlarmsNative | null {
  if (Platform.OS !== 'android') {
    return null;
  }
  try {
    return requireNativeModule<SteadyWeekAlarmsNative>('SteadyWeekAlarms');
  } catch {
    return null;
  }
}

/** True when Android will deliver alarms at the scheduled minute. */
export function canScheduleExactAlarms(): boolean {
  return nativeModule()?.canScheduleExactAlarms() ?? Platform.OS !== 'android';
}

/** True when a locked phone may launch the reminder screen. */
export function canUseFullScreenIntent(): boolean {
  return nativeModule()?.canUseFullScreenIntent() ?? Platform.OS !== 'android';
}

export function openExactAlarmSettings(): void {
  nativeModule()?.openExactAlarmSettings();
}

export function openFullScreenSettings(): void {
  nativeModule()?.openFullScreenSettings();
}

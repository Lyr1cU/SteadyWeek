import { useEffect, useRef } from 'react';
import { StyleSheet, View } from 'react-native';
import type { ShellTab } from '../../app/routes';
import { AppBackground } from '../../ui/app-background';
import { TAB_BAR_CLEARANCE } from '../../ui/motion/constants';
import { TabCrossfade } from '../../ui/motion/tab-crossfade';
import { SyncStatusBadge } from '../../ui/sync-status-badge';
import { ProfileScreen } from '../profile/profile-screen';
import { RoutineScreen } from '../routine/routine-screen';
import { TodayScreen } from '../today/today-screen';
import { WeekScreen } from '../week/week-screen';
import { ShellTabBar } from './shell-tab-bar';

/** Space reserved for floating dock (padding + pill height). */
const DOCK_LAYOUT_HEIGHT = 78;
const SYNC_ABOVE_DOCK = 10;

export function MainShell({
  tab,
  onTab,
  todayFocusDayKey,
  onTodayFocusHandled,
  onCloseDay,
  onShop,
  onAssistant,
  onWeeklyReport,
  onOpenDay,
  onAuth,
}: {
  tab: ShellTab;
  onTab: (tab: ShellTab) => void;
  todayFocusDayKey: string | null;
  onTodayFocusHandled: () => void;
  onCloseDay: (dayKey: string) => void;
  onShop: () => void;
  onAssistant: (backTab: ShellTab, dayKey?: string) => void;
  onWeeklyReport: (weekKey: string) => void;
  onOpenDay: (dayKey: string) => void;
  onAuth: () => void;
}) {
  const prevTabRef = useRef<ShellTab | null>(null);
  const prevTab = prevTabRef.current;

  useEffect(() => {
    prevTabRef.current = tab;
  }, [tab]);

  const screen =
    tab === 'today' ? (
      <TodayScreen
        focusDayKey={todayFocusDayKey}
        onFocusDayHandled={onTodayFocusHandled}
        onCloseDay={onCloseDay}
        onAssistant={(dayKey) => onAssistant('today', dayKey)}
        onWeek={() => onTab('week')}
      />
    ) : tab === 'week' ? (
      <WeekScreen onWeeklyReport={onWeeklyReport} onOpenDay={onOpenDay} />
    ) : tab === 'routine' ? (
      <RoutineScreen />
    ) : (
      <ProfileScreen onShop={onShop} onAssistant={() => onAssistant('profile')} onAuth={onAuth} />
    );

  return (
    <AppBackground>
      <View style={styles.root}>
        <View style={styles.body}>
          <TabCrossfade tab={tab} prevTab={prevTab}>
            {screen}
          </TabCrossfade>
        </View>
        <View style={styles.footer} pointerEvents="box-none">
          <View style={styles.syncAnchor} pointerEvents="box-none">
            <SyncStatusBadge />
          </View>
          <ShellTabBar tab={tab} onTab={onTab} />
        </View>
      </View>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  body: { flex: 1, paddingBottom: TAB_BAR_CLEARANCE },
  footer: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 0,
  },
  syncAnchor: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: DOCK_LAYOUT_HEIGHT + SYNC_ABOVE_DOCK,
    alignItems: 'center',
    zIndex: 10,
  },
});

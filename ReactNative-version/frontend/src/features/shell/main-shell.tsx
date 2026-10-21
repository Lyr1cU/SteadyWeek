import { useEffect, useRef } from 'react';
import { StyleSheet, View } from 'react-native';
import { shellTabs, type ShellTab } from '../../app/routes';
import { AppBackground } from '../../ui/app-background';
import { ShellPane } from '../../ui/motion/shell-pane';
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
  const tabIndex = shellTabs.indexOf(tab);
  const prevIndex = useRef(tabIndex);
  const direction: 1 | -1 = tabIndex >= prevIndex.current ? 1 : -1;

  useEffect(() => {
    prevIndex.current = tabIndex;
  }, [tabIndex]);

  return (
    <AppBackground>
      <View style={styles.root}>
        <View style={styles.body}>
          <ShellPane active={tab === 'today'} direction={direction}>
            <TodayScreen
              focusDayKey={todayFocusDayKey}
              onFocusDayHandled={onTodayFocusHandled}
              onCloseDay={onCloseDay}
              onAssistant={(dayKey) => onAssistant('today', dayKey)}
              onWeek={() => onTab('week')}
            />
          </ShellPane>
          <ShellPane active={tab === 'week'} direction={direction}>
            <WeekScreen onWeeklyReport={onWeeklyReport} onOpenDay={onOpenDay} />
          </ShellPane>
          <ShellPane active={tab === 'routine'} direction={direction}>
            <RoutineScreen />
          </ShellPane>
          <ShellPane active={tab === 'profile'} direction={direction}>
            <ProfileScreen onShop={onShop} onAssistant={() => onAssistant('profile')} onAuth={onAuth} />
          </ShellPane>
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
  body: { flex: 1 },
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

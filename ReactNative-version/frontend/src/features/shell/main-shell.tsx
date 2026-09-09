import { Pressable, StyleSheet, Text, View } from 'react-native';
import { shellTabs, type ShellTab } from '../../app/routes';
import { AppBackground } from '../../ui/app-background';
import { SyncStatusBadge } from '../../ui/sync-status-badge';
import { theme } from '../../ui/theme';
import { ProfileScreen } from '../profile/profile-screen';
import { RoutineScreen } from '../routine/routine-screen';
import { TodayScreen } from '../today/today-screen';
import { WeekScreen } from '../week/week-screen';

const labels: Record<ShellTab, string> = {
  today: 'Today',
  week: 'Week',
  routine: 'Routine',
  profile: 'Profile',
};

export function MainShell({
  tab,
  onTab,
  onCloseDay,
  onShop,
  onAssistant,
  onWeeklyReport,
  onAuth,
}: {
  tab: ShellTab;
  onTab: (tab: ShellTab) => void;
  onCloseDay: () => void;
  onShop: () => void;
  onAssistant: (backTab: ShellTab) => void;
  onWeeklyReport: () => void;
  onAuth: () => void;
}) {
  return (
    <AppBackground>
      <View style={styles.root}>
        <View style={styles.body}>
          {tab === 'today' ? (
            <TodayScreen onCloseDay={onCloseDay} onAssistant={() => onAssistant('today')} />
          ) : tab === 'week' ? (
            <WeekScreen onWeeklyReport={onWeeklyReport} />
          ) : tab === 'routine' ? (
            <RoutineScreen />
          ) : (
            <ProfileScreen onShop={onShop} onAssistant={() => onAssistant('profile')} onAuth={onAuth} />
          )}
        </View>
        <SyncStatusBadge />
        <View style={styles.tabBar}>
          {shellTabs.map((id) => (
            <Pressable
              key={id}
              onPress={() => onTab(id)}
              style={[styles.tab, tab === id && styles.tabOn]}
            >
              <Text style={[styles.tabLabel, tab === id && styles.tabLabelOn]}>{labels[id]}</Text>
            </Pressable>
          ))}
        </View>
      </View>
    </AppBackground>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  body: { flex: 1 },
  tabBar: {
    flexDirection: 'row',
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: theme.colors.border,
    backgroundColor: theme.colors.chromeSurface,
    paddingBottom: 20,
  },
  tab: { flex: 1, paddingVertical: 12, alignItems: 'center' },
  tabOn: {
    borderTopWidth: 2,
    borderTopColor: theme.colors.accent,
    backgroundColor: theme.colors.accentContainer,
  },
  tabLabel: { fontSize: 12, color: theme.colors.textSubtle, fontWeight: '600' },
  tabLabelOn: { color: theme.colors.accent },
});

import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';
import { StyleSheet, Text, View } from 'react-native';
import { shellTabs, type ShellTab } from '../../app/routes';
import { AnimatedPressable } from '../../ui/motion/animated-pressable';
import { theme } from '../../ui/theme';

const labels: Record<ShellTab, string> = {
  today: 'Today',
  week: 'Week',
  routine: 'Routine',
  profile: 'Profile',
};

const { colors } = theme;

function TabIcon({ id, active }: { id: ShellTab; active: boolean }) {
  const color = active ? colors.accent : colors.textSubtle;
  const size = 20;

  if (id === 'routine') {
    return (
      <MaterialCommunityIcons
        name="calendar-sync"
        size={size}
        color={color}
      />
    );
  }

  const name =
    id === 'today'
      ? 'calendar-outline'
      : id === 'week'
        ? 'stats-chart-outline'
        : 'person-outline';

  return <Ionicons name={name} size={size} color={color} />;
}

export function ShellTabBar({
  tab,
  onTab,
}: {
  tab: ShellTab;
  onTab: (tab: ShellTab) => void;
}) {
  return (
    <View style={styles.outer} pointerEvents="box-none">
      <View style={styles.dockShadow}>
        <View style={styles.dock}>
          {shellTabs.map((id) => {
            const active = tab === id;
            const content = (
              <>
                <View style={styles.iconWrap}>
                  <TabIcon id={id} active={active} />
                  {active && id === 'today' ? <View style={styles.todayDot} /> : null}
                </View>
                <Text style={[styles.label, active && styles.labelActive]} numberOfLines={1}>
                  {labels[id]}
                </Text>
              </>
            );

            return (
              <AnimatedPressable
                key={id}
                onPress={() => onTab(id)}
                style={styles.tabPress}
                accessibilityRole="button"
                accessibilityState={{ selected: active }}
                accessibilityLabel={labels[id]}
              >
                {active ? (
                  <LinearGradient
                    colors={[colors.navActiveGradientStart, colors.navActiveGradientEnd]}
                    start={{ x: 0, y: 0.5 }}
                    end={{ x: 1, y: 0.5 }}
                    style={styles.tabActive}
                  >
                    {content}
                  </LinearGradient>
                ) : (
                  <View style={styles.tabIdle}>{content}</View>
                )}
              </AnimatedPressable>
            );
          })}
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  outer: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 0,
    paddingHorizontal: theme.spacing.screenX - 8,
    paddingBottom: 12,
    zIndex: 1,
  },
  dockShadow: {
    borderRadius: 28,
    shadowColor: colors.accent,
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.12,
    shadowRadius: 18,
    elevation: 14,
  },
  dock: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: colors.chromeSurface,
    borderRadius: 28,
    borderWidth: 1,
    borderColor: colors.navDockBorder,
    padding: 6,
    gap: 2,
  },
  tabPress: {
    flex: 1,
    minWidth: 0,
  },
  tabActive: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
    paddingVertical: 10,
    paddingHorizontal: 6,
    borderRadius: 18,
    borderWidth: 1,
    borderColor: 'rgba(202, 184, 255, 0.22)',
    shadowColor: colors.accent,
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.35,
    shadowRadius: 10,
    elevation: 4,
  },
  tabIdle: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 4,
    paddingVertical: 10,
    paddingHorizontal: 4,
    borderRadius: 18,
  },
  iconWrap: {
    position: 'relative',
  },
  todayDot: {
    position: 'absolute',
    top: -1,
    right: -3,
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: colors.accentMuted,
  },
  label: {
    fontSize: 15,
    fontWeight: '600',
    color: colors.textSubtle,
    letterSpacing: 0.2,
  },
  labelActive: {
    color: colors.accent,
    fontWeight: '700',
  },
});

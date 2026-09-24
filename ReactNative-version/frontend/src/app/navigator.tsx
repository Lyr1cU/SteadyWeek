import { useEffect, useRef, useState } from 'react';
import { AssistantScreen } from '../features/assistant/assistant-screen';
import { AuthScreen } from '../features/auth/auth-screen';
import { CloseDayScreen } from '../features/close-day/close-day-screen';
import { OnboardingScreen } from '../features/onboarding/onboarding-screen';
import { ShopScreen } from '../features/shop/shop-screen';
import { MainShell } from '../features/shell/main-shell';
import { WeeklyReportScreen } from '../features/weekly-report/weekly-report-screen';
import { RouteSlide } from '../ui/motion/route-slide';
import { useRepos } from './repos-context';
import type { AppRoute } from './routes';

function slideDirection(prev: AppRoute | null, next: AppRoute): 'push' | 'pop' {
  if (!prev) {
    return 'push';
  }
  const prevOverlay = prev.name !== 'shell';
  const nextOverlay = next.name !== 'shell';
  if (prevOverlay && !nextOverlay) {
    return 'pop';
  }
  return 'push';
}

export function AppNavigator({
  route,
  onRoute,
}: {
  route: AppRoute;
  onRoute: (route: AppRoute) => void;
}) {
  const { settings } = useRepos();
  const [todayFocusDayKey, setTodayFocusDayKey] = useState<string | null>(null);
  const prevRouteRef = useRef<AppRoute | null>(null);
  const direction = slideDirection(prevRouteRef.current, route);

  useEffect(() => {
    prevRouteRef.current = route;
  }, [route]);

  let screen;
  switch (route.name) {
    case 'onboarding':
      screen = (
        <OnboardingScreen
          onDone={() => {
            void settings.setOnboardingComplete(true).then(() => {
              onRoute({ name: 'shell', tab: 'today' });
            });
          }}
        />
      );
      break;
    case 'auth':
      screen = (
        <AuthScreen
          onBack={() => onRoute({ name: 'shell', tab: 'profile' })}
          onSignedIn={() => onRoute({ name: 'shell', tab: 'profile' })}
        />
      );
      break;
    case 'closeDay':
      screen = (
        <CloseDayScreen
          dayKey={route.dayKey}
          onBack={() => onRoute({ name: 'shell', tab: 'today' })}
        />
      );
      break;
    case 'weeklyReport':
      screen = (
        <WeeklyReportScreen
          weekKey={route.weekKey}
          onBack={() => onRoute({ name: 'shell', tab: 'week' })}
        />
      );
      break;
    case 'shop':
      screen = <ShopScreen onBack={() => onRoute({ name: 'shell', tab: 'profile' })} />;
      break;
    case 'assistant':
      screen = (
        <AssistantScreen
          contextDayKey={route.dayKey}
          onBack={() => onRoute({ name: 'shell', tab: route.backTab })}
        />
      );
      break;
    case 'shell':
      screen = (
        <MainShell
          tab={route.tab}
          onTab={(tab) => onRoute({ name: 'shell', tab })}
          todayFocusDayKey={todayFocusDayKey}
          onTodayFocusHandled={() => setTodayFocusDayKey(null)}
          onCloseDay={(dayKey) => onRoute({ name: 'closeDay', dayKey })}
          onShop={() => onRoute({ name: 'shop' })}
          onAssistant={(backTab, dayKey) => onRoute({ name: 'assistant', backTab, dayKey })}
          onWeeklyReport={(weekKey) => onRoute({ name: 'weeklyReport', weekKey })}
          onOpenDay={(dayKey) => {
            setTodayFocusDayKey(dayKey);
            onRoute({ name: 'shell', tab: 'today' });
          }}
          onAuth={() => onRoute({ name: 'auth' })}
        />
      );
      break;
  }

  return (
    <RouteSlide routeKey={route.name} direction={direction}>
      {screen}
    </RouteSlide>
  );
}

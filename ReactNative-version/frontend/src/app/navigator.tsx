import { AssistantScreen } from '../features/assistant/assistant-screen';
import { AuthScreen } from '../features/auth/auth-screen';
import { CloseDayScreen } from '../features/close-day/close-day-screen';
import { OnboardingScreen } from '../features/onboarding/onboarding-screen';
import { ShopScreen } from '../features/shop/shop-screen';
import { MainShell } from '../features/shell/main-shell';
import { WeeklyReportScreen } from '../features/weekly-report/weekly-report-screen';
import { useRepos } from './repos-context';
import type { AppRoute } from './routes';

export function AppNavigator({
  route,
  onRoute,
}: {
  route: AppRoute;
  onRoute: (route: AppRoute) => void;
}) {
  const { settings } = useRepos();

  switch (route.name) {
    case 'onboarding':
      return (
        <OnboardingScreen
          onDone={() => {
            void settings.setOnboardingComplete(true).then(() => {
              onRoute({ name: 'shell', tab: 'today' });
            });
          }}
        />
      );
    case 'auth':
      return (
        <AuthScreen
          onBack={() => onRoute({ name: 'shell', tab: 'profile' })}
          onSignedIn={() => onRoute({ name: 'shell', tab: 'profile' })}
        />
      );
    case 'closeDay':
      return <CloseDayScreen onBack={() => onRoute({ name: 'shell', tab: 'today' })} />;
    case 'weeklyReport':
      return <WeeklyReportScreen onBack={() => onRoute({ name: 'shell', tab: 'week' })} />;
    case 'shop':
      return <ShopScreen onBack={() => onRoute({ name: 'shell', tab: 'profile' })} />;
    case 'assistant':
      return (
        <AssistantScreen onBack={() => onRoute({ name: 'shell', tab: route.backTab })} />
      );
    case 'shell':
      return (
        <MainShell
          tab={route.tab}
          onTab={(tab) => onRoute({ name: 'shell', tab })}
          onCloseDay={() => onRoute({ name: 'closeDay' })}
          onShop={() => onRoute({ name: 'shop' })}
          onAssistant={(backTab) => onRoute({ name: 'assistant', backTab })}
          onWeeklyReport={() => onRoute({ name: 'weeklyReport' })}
          onAuth={() => onRoute({ name: 'auth' })}
        />
      );
  }
}

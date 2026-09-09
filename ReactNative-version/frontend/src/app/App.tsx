import { useEffect, useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import { createAppRepositories } from './create-repos';
import { ReposProvider } from './repos-context';
import type { AppRepositories } from '../data/ports';
import type { AppRoute } from './routes';
import { BootScreen } from './boot-screen';
import { AppNavigator } from './navigator';
import { SyncProvider } from './sync-context';

export default function App() {
  const [repos, setRepos] = useState<AppRepositories | null>(null);
  const [bootError, setBootError] = useState<string | null>(null);
  const [route, setRoute] = useState<AppRoute | null>(null);

  useEffect(() => {
    createAppRepositories()
      .then(async (created) => {
        const onboardingComplete = await created.settings.isOnboardingComplete();
        setRepos(created);
        setRoute(onboardingComplete ? { name: 'shell', tab: 'today' } : { name: 'onboarding' });
      })
      .catch((error: unknown) => {
        setBootError(error instanceof Error ? error.message : 'Failed to open local database.');
      });
  }, []);

  if (bootError) {
    return (
      <>
        <StatusBar style="light" />
        <BootScreen error={bootError} />
      </>
    );
  }

  if (!repos || !route) {
    return (
      <>
        <StatusBar style="light" />
        <BootScreen />
      </>
    );
  }

  return (
    <ReposProvider repos={repos}>
      <SyncProvider>
        <StatusBar style="light" />
        <AppNavigator route={route} onRoute={setRoute} />
      </SyncProvider>
    </ReposProvider>
  );
}

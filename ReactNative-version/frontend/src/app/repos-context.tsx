import { createContext, useContext, type ReactNode } from 'react';
import type { AppRepositories } from '../data/ports';

const ReposContext = createContext<AppRepositories | null>(null);

export function ReposProvider({
  repos,
  children,
}: {
  repos: AppRepositories;
  children: ReactNode;
}) {
  return (
    <ReposContext.Provider value={repos}>{children}</ReposContext.Provider>
  );
}

export function useRepos(): AppRepositories {
  const value = useContext(ReposContext);
  if (!value) {
    throw new Error('useRepos must be used inside ReposProvider');
  }
  return value;
}

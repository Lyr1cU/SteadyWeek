import NetInfo from '@react-native-community/netinfo';
import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react';
import { ApiError } from '../data/api/client';
import { clearAuthSession, isLoggedIn } from '../data/auth/auth-store';
import type { SyncStatus } from '../data/sync/sync-engine';
import { registerSyncHandler } from '../data/sync/schedule-sync';
import { useRepos } from './repos-context';

type SyncContextValue = {
  status: SyncStatus;
  syncError: string | null;
  syncRevision: number;
  triggerSync: () => Promise<void>;
  refreshAuth: () => Promise<void>;
  loggedIn: boolean;
};

const SyncContext = createContext<SyncContextValue | null>(null);

export function SyncProvider({ children }: { children: ReactNode }) {
  const { sync } = useRepos();
  const [status, setStatus] = useState<SyncStatus>('offline');
  const [syncError, setSyncError] = useState<string | null>(null);
  const [loggedIn, setLoggedIn] = useState(false);
  const [syncRevision, setSyncRevision] = useState(0);

  const triggerSync = useCallback(async () => {
    if (!(await isLoggedIn())) {
      setStatus('offline');
      setSyncError(null);
      return;
    }

    setStatus('syncing');
    setSyncError(null);
    try {
      await sync.runSync();
      setStatus('synced');
      setSyncRevision((n) => n + 1);
    } catch (error) {
      if (error instanceof ApiError && error.status === 401) {
        await clearAuthSession();
        setLoggedIn(false);
        setStatus('offline');
        setSyncError('Session expired — sign in again');
        return;
      }

      setStatus('error');
      setSyncError(error instanceof Error ? error.message : 'Sync failed');
    }
  }, [sync]);

  const refreshAuth = useCallback(async () => {
    const authed = await isLoggedIn();
    setLoggedIn(authed);
    if (!authed) {
      setStatus('offline');
      setSyncError(null);
      return;
    }
    void triggerSync();
  }, [triggerSync]);

  useEffect(() => {
    registerSyncHandler(triggerSync);
    return () => registerSyncHandler(null);
  }, [triggerSync]);

  useEffect(() => {
    void refreshAuth();
  }, [refreshAuth]);

  useEffect(() => {
    const sub = NetInfo.addEventListener((state) => {
      if (state.isConnected && loggedIn) {
        void triggerSync();
      } else if (!loggedIn) {
        setStatus('offline');
      }
    });
    return () => sub();
  }, [loggedIn, triggerSync]);

  const value = useMemo(
    () => ({ status, syncError, syncRevision, triggerSync, refreshAuth, loggedIn }),
    [status, syncError, syncRevision, triggerSync, refreshAuth, loggedIn],
  );

  return <SyncContext.Provider value={value}>{children}</SyncContext.Provider>;
}

export function useSync(): SyncContextValue {
  const value = useContext(SyncContext);
  if (!value) {
    throw new Error('useSync must be used inside SyncProvider');
  }
  return value;
}

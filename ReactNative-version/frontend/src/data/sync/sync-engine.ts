import type { SQLiteDatabase } from 'expo-sqlite';
import { apiFetch } from '../api/client';
import { getAccessToken } from '../auth/auth-store';
import { getLastPullAt, markAllPending, setLastPullAt } from '../sqlite/sync-meta';
import { applyPull, replaceScheduleFromPull } from './apply-pull';
import { clearPendingFlags } from './clear-pending';
import { collectPending } from './collect-pending';
import { pullHasCloudData, type PullResponse } from './sync-types';

export type SyncStatus = 'offline' | 'syncing' | 'synced' | 'error';

export function createSyncEngine(db: SQLiteDatabase) {
  let status: SyncStatus = 'offline';
  let syncInFlight: Promise<void> | null = null;

  const getStatus = () => status;

  const runSync = async (): Promise<void> => {
    if (syncInFlight) {
      return syncInFlight;
    }

    syncInFlight = (async () => {
      const token = await getAccessToken();
      if (!token) {
        status = 'offline';
        return;
      }

      status = 'syncing';
      try {
        const since = await getLastPullAt(db);
        const neverPulled = since === new Date(0).toISOString() || since.startsWith('1970-01-01');

        if (neverPulled) {
          const snapshot = await apiFetch<PullResponse>('/sync/pull?since=1970-01-01T00:00:00.000Z');
          if (pullHasCloudData(snapshot)) {
            await replaceScheduleFromPull(db, snapshot);
            await setLastPullAt(db, snapshot.serverTime);
            status = 'synced';
            return;
          }

          await markAllPending(db);
        }

        const pushPayload = await collectPending(db);
        await apiFetch('/sync/push', {
          method: 'POST',
          body: JSON.stringify(pushPayload),
        });
        await clearPendingFlags(db, pushPayload);

        const pull = await apiFetch<PullResponse>(`/sync/pull?since=${encodeURIComponent(since)}`);
        await applyPull(db, pull);
        await setLastPullAt(db, pull.serverTime);
        status = 'synced';
      } catch (error) {
        status = 'error';
        throw error instanceof Error ? error : new Error('Sync failed');
      }
    })().finally(() => {
      syncInFlight = null;
    });

    return syncInFlight;
  };

  return { runSync, getStatus };
}

export type SyncEngine = ReturnType<typeof createSyncEngine>;

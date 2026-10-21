import { useEffect } from 'react';
import { AppState } from 'react-native';
import { useRepos } from '../app/repos-context';
import { useSync } from '../app/sync-context';
import { initCloseDayReminder } from './close-day-reminder';
import { syncRoutineReminders } from './routine-reminder-sync';

/** Reschedule alarms when templates change, after sync, or when returning from system settings. */
export function useRoutineReminderSync() {
  const { routine } = useRepos();
  const { syncRevision } = useSync();

  useEffect(() => {
    let cancelled = false;
    const run = () => {
      void (async () => {
        const items = await routine.listTemplates();
        if (cancelled) {
          return;
        }
        await syncRoutineReminders(items);
        if (!cancelled) {
          await initCloseDayReminder();
        }
      })();
    };

    run();
    const sub = AppState.addEventListener('change', (state) => {
      if (state === 'active') {
        run();
      }
    });
    return () => {
      cancelled = true;
      sub.remove();
    };
  }, [routine, syncRevision]);
}

let syncHandler: (() => Promise<void>) | null = null;
let debounceTimer: ReturnType<typeof setTimeout> | null = null;

const DEBOUNCE_MS = 400;

export function registerSyncHandler(handler: (() => Promise<void>) | null): void {
  syncHandler = handler;
}

/** Fire-and-forget sync after a local SQLite write (debounced). */
export function scheduleSync(): void {
  if (!syncHandler) {
    return;
  }
  if (debounceTimer) {
    clearTimeout(debounceTimer);
  }
  debounceTimer = setTimeout(() => {
    debounceTimer = null;
    void syncHandler?.();
  }, DEBOUNCE_MS);
}

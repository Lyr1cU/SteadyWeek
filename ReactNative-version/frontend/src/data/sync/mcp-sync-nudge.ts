/** Must match backend `MCP_SYNC_NUDGE_SETTING_KEY`. */
export const MCP_SYNC_NUDGE_SETTING_KEY = 'steadyweek_mcp_nudge';

type McpNudgeListener = () => void;
const listeners = new Set<McpNudgeListener>();

export function onMcpSyncNudge(listener: McpNudgeListener): () => void {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

export function emitMcpSyncNudge(): void {
  for (const listener of listeners) {
    listener();
  }
}

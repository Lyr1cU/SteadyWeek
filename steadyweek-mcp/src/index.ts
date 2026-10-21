#!/usr/bin/env node

import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { SteadyWeekApi } from './api.js';
import { loadConfig } from './config.js';
import { registerTools } from './tools.js';

async function main() {
  const config = loadConfig();
  const api = new SteadyWeekApi(config);
  await api.ensureAuth();

  const server = new McpServer({
    name: 'steadyweek',
    version: '0.2.1',
  });

  registerTools(server, api, config);

  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});

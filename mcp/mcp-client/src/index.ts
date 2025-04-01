import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import { AsepriteClient } from "./AsepriteClient.js";
import { createSpriteTools } from "./tools/sprite.js";

export const sessionId:number = 0;

// Create server instance
const server = new McpServer({
  name: "mcp-Aseprite",
  version: "1.0.0",
  capabilities: {
    resources: {},
    tools: {},
  },
});

const asepriteClient = new AsepriteClient();

createSpriteTools(server, asepriteClient);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  process.exit(1);
});

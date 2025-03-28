import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { AsepriteClient } from "./AsepriteClient.js";
import { createSpriteTools } from "./tools/sprite.js";
export const sessionId = 0;
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
asepriteClient.connect();
createSpriteTools(server, asepriteClient);
async function main() {
    const transport = new StdioServerTransport();
    await server.connect(transport);
    console.error("Weather MCP Server running on stdio");
}
main().catch((error) => {
    console.error("Fatal error in main():", error);
    process.exit(1);
});

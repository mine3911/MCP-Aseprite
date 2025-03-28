import { z } from "zod";
import { sessionId } from "../index.js";
export const createSpriteTools = (server, asepriteClient) => {
    server.tool("create-sprite", "在Aseprite中创建sprite", {
        width: z.string().describe("Sprite width"),
        height: z.string().describe("Sprite height"),
    }, async ({ width, height }) => {
        const obj = new Struct_CreateSprite();
        obj.width = parseInt(width);
        obj.height = parseInt(height);
        const sId = sessionId + 1;
        asepriteClient.sendMessage(sId, "create-sprite", JSON.stringify(obj));
        const result = await asepriteClient.getCallBack(sId);
        return {
            content: [
                {
                    type: "text",
                    text: result ? "Task Success" : "Task Failed",
                },
            ],
        };
    });
};
export class Struct_CreateSprite {
    width = 0;
    height = 0;
}

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
        await asepriteClient.checkConnection();
        asepriteClient.sendMessage(sId, "create-sprite", JSON.stringify(obj));
        const result = await asepriteClient.getCallBack(sId);
        return {
            content: [
                {
                    type: "text",
                    text: result.succ ? "Task Success" : "Task Failed,Reason:" + result.reason,
                },
            ],
        };
    });
    server.tool("draw-pixel", "在Aseprite中的当前Sprite中绘画像素点。有三种模式可用：1、单点像素绘制（传入一个点坐标）；2、连线绘制（传入两个点坐标，绘制这两个点形成的线）；3、填充模式（传入一个点的坐标，填充绘制这个点所在的区域）", {
        jsonStr: z.string().describe('数组类型的json串，格式为: [{"drawType":"1","targetLayer":"1","targetFrame":"1","createFrameMode":"1","posStr":"","color_r":"0","color_g":"0","color_b":"0","color_a":"0"},{...}]' +
            '。其中drawType为绘制像素模式，1：单点绘制（传入一个点的坐标），2：连线绘制（传入两点坐标，确定一条直线，然后绘制线条），3：填充模式（传入一个点的坐标，然后填充该点所在的区域）' +
            '。targetLayer为绘制目标图层。targetFrame为绘制目标帧。createFrameMode为创建帧模式，1：创建一个空的frame，2：创建一个与上一个frame相同尺寸的frame，并复制上一个frame的图像数据' +
            '。posStr为绘制位置，格式："x1,y1;x2,y2"' +
            '。color_r、color_g、color_b、color_a为像素点的颜色，范围0-255' +
            '。之所以要传数组类型的json串，是因为可以将多个绘制步骤串连起来，减少请求次数。即使只有一个绘制步骤，也要传数组，因为要保证请求的格式统一。为了保证步骤清晰易懂，请数组长度最大不超过10'),
    }, async ({ jsonStr }) => {
        const sId = sessionId + 1;
        asepriteClient.sendMessage(sId, "draw-pixel", jsonStr);
        const result = await asepriteClient.getCallBack(sId);
        return {
            content: [
                {
                    type: "text",
                    text: result.succ ? "Task Success" : "Task Failed,Reason:" + result.reason,
                },
            ],
        };
    });
};
export class Struct_CreateSprite {
    width = 0;
    height = 0;
}

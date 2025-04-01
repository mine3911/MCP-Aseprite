MessageStruct = {
    sessionID = "",
    command = "",
    body = ""
}

function Create_MessageStruct(json_data)
    return {
        sessionID = json_data.sessionID,
        command = json_data.command,
        body = json_data.body
    }
end

Struct_CreateSprite = {
    width = 0,
    height = 0,
}

Struct_DrawPixel = {
    -- 绘制像素模式，1：单点绘制（传入一个点的坐标），2：连线绘制（传入两点坐标，确定一条直线，然后绘制线条），3：填充模式（传入一个点的坐标，然后填充该点所在的区域）
    drawType = 1,
    targetLayer = 1,
    targetFrame = 1,
    createFrameMode = 1,    --创建frame时的模式，1：创建一个空的frame，2：创建一个与上一个frame相同尺寸的frame，并复制上一个frame的图像数据
    posStr = "", -- 格式："x1,y1;x2,y2"
    color_r = 0,
    color_g = 0,
    color_b = 0,
    color_a = 0
}
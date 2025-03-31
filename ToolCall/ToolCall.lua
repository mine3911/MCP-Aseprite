local SystemTool = require("./ToolCall.SystemTool")
local structDefine = require("./StructDefine/StructDefine")

local returnInfo = {
    processSucc = true,
    reason = ""
}

function HandleMessage(messageDistruct)
    local command = messageDistruct.command
    local bodyJsonStr = messageDistruct.body

    print("解析为指令：" .. command .. "，参数：" .. bodyJsonStr)

    local info = returnInfo.new()

    if command == "create-sprite" then
        Call_CreateSprite(bodyJsonStr, info)
    else
        info.processSucc = false
        info.reason = "未知指令:" .. command .. " Aseprite 插件不支持该指令"
    end

    return info
end

--========================================================

--绘制像素
function Call_DrawPixel(jsonBody, info)
    info.processSucc = true

    local decodeObj = DecodeJsonToObj(jsonBody)
    if (decodeObj == nil) or type(decodeObj) ~= "table" or #decodeObj <= 0 then
        info.processSucc = false
        info.reason = "参数解析反序列化失败"
        return
    end

    local sprite = app.sprite
    if not sprite then
        info.processSucc = false
        info.reason = "未找到当前Sprite,需要新建Sprite"
        return
    end
    local width = sprite.width
    local height = sprite.height

    for i, obj in ipairs(decodeObj) do
        local drawType = obj.drawType
        local targetLayer = obj.targetLayer
        local targetFrame = obj.targetFrame
        local createFrameMode = obj.createFrameMode
        local posStr = obj.posStr
        local color_r = obj.color_r
        local color_g = obj.color_g
        local color_b = obj.color_b
        local color_a = obj.color_a

        SystemTool.CheckLayerAndFrame(sprite, targetLayer, targetFrame, createFrameMode)

        -- 创建一个数组来保存分割后的坐标
        local posArray = {}

        -- 分割 posStr 以 ';' 字符
        for coordStr in string.gmatch(posStr, "([^;]+)") do
            -- 解析每个坐标字符串为 x 和 y
            local posX, posY = coordStr:match("(%d+),(%d+)")
            if posX and posY then
                posX = tonumber(posX)
                posY = tonumber(posY)

                -- 验证坐标范围
                if posX < 0 or posX >= width or posY < 0 or posY >= height then
                    info.processSucc = false
                    info.reason = "绘制位置超出Sprite尺寸,Sprite 尺寸:" .. width .. "x" .. height .. " 坐标:" .. coordStr
                    return
                end

                -- 将有效的坐标添加到数组中
                table.insert(posArray, { x = posX, y = posY })
            else
                info.processSucc = false
                info.reason = "坐标格式错误:" .. coordStr
                return
            end
        end

        local layer = sprite.layers[targetLayer]
        if not layer then
            info.processSucc = false
            info.reason = "未找到指定Layer:" .. targetLayer .. ",layers目前数量：" .. #sprite.layers
            return
        end

        local cel = layer:cel(targetFrame)
        if not cel then
            cel = app.sprite:newCel(targetLayer, targetFrame)
        end
        if not cel then
            info.processSucc = false
            info.reason = "未找到指定帧:" .. targetFrame
            return
        end

        local image = cel.image
        if not image then
            info.processSucc = false
            info.reason = "未找到Layer:" .. targetLayer .. ",frame:" .. targetFrame .. "下的Image信息"
            return
        end

        local targetColor = app.pixelColor.rgba(color_r, color_g, color_b, color_a)

        if drawType == 1 then
            -- 单点绘制
            for _, pos in ipairs(posArray) do
                local posX = pos.x
                local posY = pos.y
                SystemTool:drawPixel(image, posX, posY, targetColor)
            end
        elseif drawType == 2 then
            -- 连线绘制
            for i = 1, #posArray - 1 do
                local posX1 = posArray[i].x
                local posY1 = posArray[i].y
                local posX2 = posArray[i + 1].x
                local posY2 = posArray[i + 1].y
                SystemTool.DrawLine(image, posX1, posY1, posX2, posY2, targetColor)
            end
        elseif drawType == 3 then
            -- 填充模式
            for _, pos in ipairs(posArray) do
                local posX = pos.x
                local posY = pos.y
                SystemTool.FillAreaColor(image, posX, posY, targetColor)
            end
        else
            info.processSucc = false
            info.reason = "未知绘制模式:" .. drawType
            return
        end
    end

    app.refresh()
end

--创建Sprite
function Call_CreateSprite(jsonBody, info)
    info.processSucc = true

    local decodeObj = DecodeJsonToObj(jsonBody)
    if (decodeObj == nil) or type(decodeObj) ~= "table" then
        info.processSucc = false
        info.reason = "参数解析反序列化失败"
        return
    end

    local width = decodeObj.width
    local height = decodeObj.height

    -- 输入验证：确保宽度和高度有效
    if width and height then
        width = tonumber(width)
        height = tonumber(height)
        if type(width) == "number" and type(height) == "number" then
            app.activeSprite = Sprite(width, height)
            -- 获取或创建调色板
            local palette = Palette({ fromResource = "DB32" })
            app.activeSprite:setPalette(palette) -- 设置为当前帧的调色板 (索引 1)
        else
            info.processSucc = false
            info.reason = "无效的尺寸参数" .. width .. "x" .. height
        end
    else
        info.processSucc = false
        info.reason = "尺寸格式错误" .. width .. "x" .. height
    end
end

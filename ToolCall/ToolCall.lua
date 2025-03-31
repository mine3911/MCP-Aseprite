function HandleMessage(messageDistruct)

    local command = messageDistruct.command
    local bodyJsonStr = messageDistruct.body

    print("解析为指令：" .. command .. "，参数：" .. bodyJsonStr)

    local processSucc = true

    if command == "create-sprite" then
        Call_CreateSprite(bodyJsonStr)
    else
        processSucc = false;
    end

    return processSucc and "1" or "0"
end

--========================================================

--创建Sprite
function Call_CreateSprite(jsonBody)

    local decodeObj, pos, error = json.decode(jsonBody)
    if error then
        print("JSON 反序列化失败: " .. error .. " msg:" .. jsonBody)
        return
    else
        print("JSON 反序列化成功")
    end

    local structDistruct = Create_Struct_CreateSprite(decodeObj)
    local width = structDistruct.width
    local height = structDistruct.height

    -- 输入验证：确保宽度和高度有效
    if width and height then
        width = tonumber(width)
        height = tonumber(height)
        if type(width) == "number" and type(height) == "number" then
            app.activeSprite = Sprite(width, height)
            -- 获取或创建调色板
            local palette = Palette({fromResource="DB32"})
            app.activeSprite:setPalette(palette) -- 设置为当前帧的调色板 (索引 1)
        else
            print("无效的尺寸参数: " .. width .. "x" .. height)
        end
    else
        print("尺寸格式错误: " .. width .. "x" .. height)
    end
end

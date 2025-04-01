function DecodeJsonToObj(jsonData)
    local decodeObj, pos, error = json.decode(jsonData)
    if error then
        print("JSON 反序列化失败: " .. error .. " msg:" .. jsonData)
        return nil
    else
        print("JSON 反序列化成功")
        return decodeObj
    end
end

function CheckLayerAndFrame(sprite, targetLayer, targetFrame,createFrameMode)
    while #sprite.layers < targetLayer do
        sprite:newLayer()
    end
    while #sprite.frames < targetFrame do
        if createFrameMode == 1 then
            sprite:newEmptyFrame()
        elseif createFrameMode == 2 then
            sprite:newFrame()
        else
            sprite:newFrame()
        end
    end
end

function DrawPixel(image, x, y, color)
    image:drawPixel(x, y, color)
end

function DrawLine(image, x1, y1, x2, y2, color)
    -- Bresenham 算法绘制直线
    local dx = math.abs(x2 - x1)
    local dy = -math.abs(y2 - y1)
    local sx = x1 < x2 and 1 or -1
    local sy = y1 < y2 and 1 or -1
    local err = dx + dy

    while true do
        DrawPixel(image,x1, y1, color)
        if x1 == x2 and y1 == y2 then
            break
        end
        local e2 = 2 * err
        if e2 >= dy then
            err = err + dy
            x1 = x1 + sx
        end
        if e2 <= dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

-- 填充坐标所在区域颜色
function FillAreaColor(image, x, y, color)
    -- 获取当前像素的颜色
    local currentColor = image:getPixel(x, y)
    -- 如果当前像素已经是目标颜色，直接返回
    if currentColor == color then
        return
    end
    local width = image.cel.sprite.width
    local height = image.cel.sprite.height

    -- 递归填充函数
    local function fill(x, y)
        -- 检查边界条件
        if x < 0 or x >= width or y < 0 or y >= height then
            return
        end

        -- 如果当前像素不是要填充的颜色，直接返回
        if image:getPixel(x, y) ~= currentColor then
            return
        end

        -- 绘制像素
        DrawPixel(image,x, y, color)

        -- 递归填充上下左右四个方向
        fill(x + 1, y)
        fill(x - 1, y)
        fill(x, y + 1)
        fill(x, y - 1)
    end

    -- 开始填充
    fill(x, y)
end

function DecodeJsonToObj(jsonData)
    local decodeObj, pos, error = json.decode(jsonData)
    if error then
        print("JSON deserialization failed: " .. error .. " msg:" .. jsonData)
        return nil
    else
        print("JSON deserialization successful")
        return decodeObj
    end
end

function CheckLayerAndFrame(sprite, targetLayer, targetFrame, createFrameMode)
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
    -- Bresenham algorithm to draw a line
    local dx = math.abs(x2 - x1)
    local dy = -math.abs(y2 - y1)
    local sx = x1 < x2 and 1 or -1
    local sy = y1 < y2 and 1 or -1
    local err = dx + dy

    while true do
        DrawPixel(image, x1, y1, color)
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

-- Fill the area with the specified color starting from the given coordinates
function FillAreaColor(image, x, y, color)
    -- Get the color of the current pixel
    local currentColor = image:getPixel(x, y)
    -- If the current pixel is already the target color, return
    if currentColor == color then
        return
    end
    local width = image.cel.sprite.width
    local height = image.cel.sprite.height

    -- Recursive fill function
    local function fill(x, y)
        -- Check boundary conditions
        if x < 0 or x >= width or y < 0 or y >= height then
            return
        end

        -- If the current pixel is not the color to be filled, return
        if image:getPixel(x, y) ~= currentColor then
            return
        end

        -- Draw the pixel
        DrawPixel(image, x, y, color)

        -- Recursively fill the four adjacent directions
        fill(x + 1, y)
        fill(x - 1, y)
        fill(x, y + 1)
        fill(x, y - 1)
    end

    -- Start filling
    fill(x, y)
end
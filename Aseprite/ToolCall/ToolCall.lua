local SystemTool = require("./ToolCall.SystemTool")

local returnInfo = {
    processSucc = true,
    reason = ""
}

function HandleMessage(messageDistruct)
    local command = messageDistruct.command
    local bodyJsonStr = messageDistruct.body

    print("Parsed command: " .. command .. ", parameters: " .. bodyJsonStr)

    local info = {
        processSucc = true,
        reason = ""
    }

    if command == "create-sprite" then
        Call_CreateSprite(bodyJsonStr, info)
    elseif command == "draw-pixel" then
        Call_DrawPixel(bodyJsonStr, info)
    else
        info.processSucc = false
        info.reason = "Unknown command: " .. command .. ". Aseprite plugin does not support this command"
    end

    return info
end

--========================================================

-- Draw pixel
function Call_DrawPixel(jsonBody, info)
    info.processSucc = true

    local decodeObj = DecodeJsonToObj(jsonBody)
    if (decodeObj == nil) or (#decodeObj <= 0) then
        info.processSucc = false
        info.reason = "Parameter parsing deserialization failed"
        return
    end

    local sprite = app.sprite
    if not sprite then
        info.processSucc = false
        info.reason = "Current Sprite not found, need to create a new Sprite"
        return
    end
    local width = sprite.width
    local height = sprite.height

    for i, obj in ipairs(decodeObj) do
        local drawType = tonumber(obj.drawType)
        local targetLayer = tonumber(obj.targetLayer)
        local targetFrame = tonumber(obj.targetFrame)
        local createFrameMode = tonumber(obj.createFrameMode)
        local posStr = obj.posStr
        local color_r = tonumber(obj.color_r)
        local color_g = tonumber(obj.color_g)
        local color_b = tonumber(obj.color_b)
        local color_a = tonumber(obj.color_a)

        CheckLayerAndFrame(sprite, targetLayer, targetFrame, createFrameMode)

        -- Create an array to save the split coordinates
        local posArray = {}

        -- Split posStr by ';' character
        for coordStr in string.gmatch(posStr, "([^;]+)") do
            -- Parse each coordinate string into x and y
            local posX, posY = coordStr:match("(%d+),(%d+)")
            if posX and posY then
                posX = tonumber(posX)
                posY = tonumber(posY)

                -- Validate coordinate range
                if posX < 0 or posX >= width or posY < 0 or posY >= height then
                    info.processSucc = false
                    info.reason = "Drawing position exceeds Sprite dimensions, Sprite size: " ..
                    width .. "x" .. height .. " Coordinate: " .. coordStr
                    return
                end

                -- Add valid coordinates to the array
                table.insert(posArray, { x = posX, y = posY })
            else
                info.processSucc = false
                info.reason = "Coordinate format error: " .. coordStr
                return
            end
        end

        local layer = sprite.layers[targetLayer]
        if not layer then
            info.processSucc = false
            info.reason = "Specified Layer not found: " ..
            targetLayer .. ", current number of layers: " .. #sprite.layers
            return
        end

        local cel = layer:cel(targetFrame)
        if not cel then
            cel = app.sprite:newCel(targetLayer, targetFrame)
        end
        if not cel then
            info.processSucc = false
            info.reason = "Specified frame not found: " .. targetFrame
            return
        end

        local image = cel.image
        if not image then
            info.processSucc = false
            info.reason = "Image information not found under Layer: " .. targetLayer .. ", frame: " .. targetFrame
            return
        end

        local targetColor = app.pixelColor.rgba(color_r, color_g, color_b, color_a)

        if drawType == 1 then
            -- Single point drawing
            for _, pos in ipairs(posArray) do
                local posX = pos.x
                local posY = pos.y
                DrawPixel(image, posX, posY, targetColor)
            end
        elseif drawType == 2 then
            -- Line drawing
            for i = 1, #posArray - 1 do
                local posX1 = posArray[i].x
                local posY1 = posArray[i].y
                local posX2 = posArray[i + 1].x
                local posY2 = posArray[i + 1].y
                DrawLine(image, posX1, posY1, posX2, posY2, targetColor)
            end
        elseif drawType == 3 then
            -- Fill mode
            for _, pos in ipairs(posArray) do
                local posX = pos.x
                local posY = pos.y
                FillAreaColor(image, posX, posY, targetColor)
            end
        else
            info.processSucc = false
            info.reason = "Unknown drawing mode: " .. drawType
            return
        end
    end

    app.refresh()
end

-- Create Sprite
function Call_CreateSprite(jsonBody, info)
    info.processSucc = true

    local decodeObj = DecodeJsonToObj(jsonBody)
    if (decodeObj == nil) then
        info.processSucc = false
        info.reason = "Parameter parsing deserialization failed"
        return
    end

    local width = decodeObj.width
    local height = decodeObj.height

    -- Input validation: ensure width and height are valid
    if width and height then
        width = tonumber(width)
        height = tonumber(height)
        if type(width) == "number" and type(height) == "number" then
            app.activeSprite = Sprite(width, height)
            -- Get or create palette
            local palette = Palette({ fromResource = "DB32" })
            app.activeSprite:setPalette(palette) -- Set as the palette for the current frame (index 1)
        else
            info.processSucc = false
            info.reason = "Invalid dimension parameters: " .. width .. "x" .. height
        end
    else
        info.processSucc = false
        info.reason = "Dimension format error: " .. width .. "x" .. height
    end
end

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
    -- Drawing pixel mode, 1: single point drawing (pass in one point's coordinates), 2: line drawing (pass in two points' coordinates to determine a straight line, then draw the line), 3: fill mode (pass in one point's coordinates, then fill the area where the point is located)
    drawType = 1,
    targetLayer = 1,
    targetFrame = 1,
    createFrameMode = 1,    -- Mode when creating a frame, 1: create an empty frame, 2: create a frame with the same size as the previous frame and copy the image data from the previous frame
    posStr = "", -- Format: "x1,y1;x2,y2"
    color_r = 0,
    color_g = 0,
    color_b = 0,
    color_a = 0
}
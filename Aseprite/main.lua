local toolCall = require("scripts.ToolCall.ToolCall")
local tool = require("scripts.ToolCall.SystemTool")

local function handleMessage(mt, data)
    if mt == WebSocketMessageType.OPEN then
        print("Connection open. Sending a message...")
  
    elseif mt == WebSocketMessageType.TEXT then
        print("Received message: " .. data)

        -- Parse message
        local decodeObj = DecodeJsonToObj(data)

        local messageDistruct = Create_MessageStruct(decodeObj)
        local result = HandleMessage(messageDistruct)

        Ws:sendText(messageDistruct.sessionID .. ";;" .. ((result.processSucc and "1") or "0") .. ";;" .. result.reason)

    elseif mt == WebSocketMessageType.CLOSE then
        print("Connection closed")
    end
end

Ws = WebSocket{
    onreceive = handleMessage,
    url = "ws://127.0.0.1:8848",
    deflate = false
}

-- Manually trigger connection (or auto-connect)
Ws:connect()

local dlg = Dialog { title = "MCP-Aseprite", onclose = OnDlgClose }
function OnDlgClose()
    Ws:close()
end

dlg:show { wait = false }
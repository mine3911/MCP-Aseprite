local toolCall = require("scripts.ToolCall.ToolCall")
local tool = require("scripts.ToolCall.SystemTool")

local function handleMessage(mt, data)
    if mt == WebSocketMessageType.OPEN then
      print("Connection open. Sending a message...")
  
    elseif mt == WebSocketMessageType.TEXT then
      print("收到消息: " .. data)

      -- 解析消息
      local decodeObj = DecodeJsonToObj(data)

      local messageDistruct = Create_MessageStruct(decodeObj)
      local result = HandleMessage(messageDistruct)

      Ws:sendText(messageDistruct.sessionID .. ";;" .. result)

    elseif mt == WebSocketMessageType.CLOSE then
      print("Connection closed")
    end
end

Ws = WebSocket{
    onreceive = handleMessage,
    url = "ws://127.0.0.1:8848",
    deflate = false
}

-- 手动触发连接（或自动连接）
Ws:connect()

local dlg = Dialog { title = "MCP-Aseprite",onclose=OnDlgClose }
function OnDlgClose()
    Ws:close()
end

dlg:show {wait=false}

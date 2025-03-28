local toolCall = require("scripts.ToolCall.ToolCall")
local structDefine = require("./StructDefine/StructDefine")

local function handleMessage(mt, data)
    if mt == WebSocketMessageType.OPEN then
      print("Connection open. Sending a message...")
  
    elseif mt == WebSocketMessageType.TEXT then
      print("收到消息: " .. data)

      local decodeObj, pos, error = json.decode(data)
      if error then
          print("JSON 反序列化失败: " .. error .. " msg:" .. data)
          return
      else
          print("JSON 反序列化成功 ")
      end

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

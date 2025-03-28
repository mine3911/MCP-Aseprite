MessageStruct = {
    sessionID="",
    command="",
    body=""
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

function Create_Struct_CreateSprite(json_data)
    return {
        width = json_data.width,
        height = json_data.height
    }
end
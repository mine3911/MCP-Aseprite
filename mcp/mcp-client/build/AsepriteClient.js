export class MessageStruct {
    sessionID = "";
    command = "";
    body = "";
}
export class AsepriteClient {
    url = "ws://localhost:8848";
    client;
    //已经完成的请求
    completedRequests = new Map();
    singleRequestWaitCount = 50;
    connected = false;
    constructor() { }
    sendMessage(sessionId, command, body) {
        let msg = new MessageStruct();
        msg.sessionID = sessionId.toString();
        msg.command = command;
        msg.body = body;
        this.client?.send(JSON.stringify(msg));
    }
    async getCallBack(sessionId) {
        const waitTime = this.singleRequestWaitCount;
        while (waitTime > 0) {
            if (this.completedRequests.has(sessionId)) {
                const result = this.completedRequests.get(sessionId);
                if (!result)
                    break;
                const succ = result.succ;
                const reason = result.reason;
                this.completedRequests.delete(sessionId);
                return { succ, reason };
            }
            await new Promise((resolve) => setTimeout(resolve, 100));
        }
        return { succ: false, reason: "未及时收到Aseprite回执结果" };
    }
    async checkConnection() {
        if (this.client?.readyState === WebSocket.OPEN) {
            return true;
        }
        this.connect();
        var waitCount = 50;
        while (this.connected == false && waitCount > 0) {
            await new Promise((resolve) => setTimeout(resolve, 100));
            waitCount--;
        }
        return false;
    }
    connect() {
        // 创建 WebSocket 客户端实例
        this.client = new WebSocket("ws://localhost:8848");
        // 连接成功后的回调
        this.client.addEventListener("open", () => {
            this.connected = true;
        });
        // 接收到消息的回调
        this.client.addEventListener("message", (event) => {
            const message = event.data; // 使用 event.data 获取消息内容
            if (message != null && message.length > 0) {
                //   console.log("收到消息:", message);
                const strs = message.split(";;");
                if (strs.length >= 2) {
                    const sessionId = parseInt(strs[0]);
                    if (sessionId > 0) {
                        this.completedRequests.set(sessionId, {
                            succ: strs[1] == "1",
                            reason: strs.length > 2 ? strs[2] : "",
                        });
                    }
                }
            }
        });
        // 连接关闭的回调
        this.client.addEventListener("close", (event) => {
            console.log("连接已关闭，代码:", event.code, ", 原因:", event.reason);
        });
        // 连接错误的回调
        this.client.addEventListener("error", (error) => {
            console.error("连接错误:", error);
        });
    }
}

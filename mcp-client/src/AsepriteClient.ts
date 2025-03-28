export class MessageStruct {
  sessionID = "";
  command = "";
  body = "";
}

export class AsepriteClient {
  url: string = "ws://localhost:8848";
  client: WebSocket | undefined;

  //已经完成的请求
  completedRequests: Map<number, boolean> = new Map();

  singleRequestWaitCount: number = 50;

  constructor() {}

  sendMessage(sessionId: number, command: string, body: string) {
    let msg = new MessageStruct();
    msg.sessionID = sessionId.toString();
    msg.command = command;
    msg.body = body;
    this.client?.send(JSON.stringify(msg));
  }

  async getCallBack(sessionId: number):Promise<boolean | undefined> {
    const waitTime = this.singleRequestWaitCount;
    while (waitTime > 0) {
        if(this.completedRequests.has(sessionId)){
            const succ = this.completedRequests.get(sessionId);
            this.completedRequests.delete(sessionId);
            return succ;
        }
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    return false;
  }

  connect() {
    // 创建 WebSocket 客户端实例
    this.client = new WebSocket("ws://localhost:8848");

    // 连接成功后的回调
    this.client.addEventListener("open", () => {
      console.log("连接已建立！");
    });

    // 接收到消息的回调
    this.client.addEventListener("message", (event: MessageEvent<string>) => {
      const message = event.data; // 使用 event.data 获取消息内容
      console.log("收到消息:", message);
      if(message != null && message.length > 0){
        const strs = message.split(";;");
        if(strs.length == 2){
            const sessionId = parseInt(strs[0]);
            if(sessionId > 0){
                this.completedRequests.set(sessionId, strs[1] == "1");
            }
        }
      }
    });

    // 连接关闭的回调
    this.client.addEventListener("close", (event: CloseEvent) => {
      console.log("连接已关闭，代码:", event.code, ", 原因:", event.reason);
    });

    // 连接错误的回调
    this.client.addEventListener("error", (error: Event) => {
      console.error("连接错误:", error);
    });
  }
}

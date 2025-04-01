export class MessageStruct {
  sessionID = "";
  command = "";
  body = "";
}

export class AsepriteClient {
  url: string = "ws://localhost:8848";
  client: WebSocket | undefined;

  // Completed requests
  completedRequests: Map<number, { succ: boolean; reason: string }> = new Map();

  singleRequestWaitCount: number = 50;
  connected: boolean = false;

  constructor() {}

  sendMessage(sessionId: number, command: string, body: string) {
    let msg = new MessageStruct();
    msg.sessionID = sessionId.toString();
    msg.command = command;
    msg.body = body;
    this.client?.send(JSON.stringify(msg));
  }

  async getCallBack(
    sessionId: number
  ): Promise<{ succ: boolean; reason: string }> {
    const waitTime = this.singleRequestWaitCount;
    while (waitTime > 0) {
      if (this.completedRequests.has(sessionId)) {
        const result = this.completedRequests.get(sessionId);
        if (!result) break;
        const succ = result.succ;
        const reason = result.reason;
        this.completedRequests.delete(sessionId);
        return { succ, reason };
      }
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    return { succ: false, reason: "Did not receive Aseprite response in time" };
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
    // Create WebSocket client instance
    this.client = new WebSocket("ws://localhost:8848");

    // Callback when connection is open
    this.client.addEventListener("open", () => {
      this.connected = true;
    });

    // Callback when a message is received
    this.client.addEventListener("message", (event: MessageEvent<string>) => {
      const message = event.data; // Use event.data to get message content

      if (message != null && message.length > 0) {
        //   console.log("Received message:", message);
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

    // Callback when connection is closed
    this.client.addEventListener("close", (event: CloseEvent) => {
      console.log("Connection closed, code:", event.code, ", reason:", event.reason);
    });

    // Callback when there is a connection error
    this.client.addEventListener("error", (error: Event) => {
      console.error("Connection error:", error);
    });
  }
}
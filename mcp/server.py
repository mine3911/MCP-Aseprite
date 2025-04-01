import asyncio
import websockets

# 用于存储连接的客户端
clients = {}

async def server(websocket):
    if len(clients) < 2:
        client_id = 'A' if 'A' not in clients else 'B'
        clients[client_id] = websocket
        print(f"新客户端 {client_id} 连接")
        # await websocket.send(f"connect server Success")
        
        try:
            async for message in websocket:
                print(f"收到客户端 {client_id} 消息，转发至其他端: {message}")
                if client_id == 'A' and 'B' in clients:
                    await clients['B'].send(message)
                elif client_id == 'B' and 'A' in clients:
                    await clients['A'].send(message)
        except websockets.exceptions.ConnectionClosed:
            print(f"客户端 {client_id} 断连")
        finally:
            print(f"客户端 {client_id} 断连")
            del clients[client_id]
    else:
        await websocket.send("Server is full. Please try again later.")
        await websocket.close()

async def main():
    print("服务器启动")
    async with websockets.serve(server, "localhost", 8848):
        await asyncio.Future()  # 永久运行

if __name__ == "__main__":
    asyncio.run(main())
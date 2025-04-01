import asyncio
import websockets

# Used to store connected clients
clients = {}

async def server(websocket):
    if len(clients) < 2:
        client_id = 'A' if 'A' not in clients else 'B'
        clients[client_id] = websocket
        print(f"New client {client_id} connected")
        # await websocket.send(f"connect server Success")
        
        try:
            async for message in websocket:
                print(f"Received message from client {client_id}, forwarding to other client: {message}")
                if client_id == 'A' and 'B' in clients:
                    await clients['B'].send(message)
                elif client_id == 'B' and 'A' in clients:
                    await clients['A'].send(message)
        except websockets.exceptions.ConnectionClosed:
            print(f"Client {client_id} disconnected")
        finally:
            print(f"Client {client_id} disconnected")
            del clients[client_id]
    else:
        await websocket.send("Server is full. Please try again later.")
        await websocket.close()

async def main():
    print("Server started")
    async with websockets.serve(server, "localhost", 8848):
        await asyncio.Future()  # Run forever

if __name__ == "__main__":
    asyncio.run(main())
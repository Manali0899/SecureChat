import asyncio
import websockets

# Keep track of all connected clients
clients = set()

async def chat_handler(websocket):
    # Add the new client to our set
    clients.add(websocket)
    print(f"🔗 Client connected. Total: {len(clients)}")
    try:
        async for message in websocket:
            print(f"📩 Received: {message}")
            # Broadcast the message to all other clients
            await asyncio.gather(*(c.send(message) for c in clients if c != websocket))
    except websockets.ConnectionClosed:
        print("❌ Client disconnected.")
    finally:
        # Remove client when it disconnects
        clients.remove(websocket)

async def main():
    async with websockets.serve(chat_handler, "localhost", 8765):
        print("✅ WebSocket server running on ws://localhost:8765")
        await asyncio.Future()  # run forever

if __name__ == "__main__":
    asyncio.run(main())

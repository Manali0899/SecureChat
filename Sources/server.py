# server.py
import socket

HOST = "127.0.0.1"
PORT = 65432

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    print(f"Server running on {HOST}:{PORT}")
    while True:
        conn, addr = s.accept()
        with conn:
            print("Connected by", addr)
            while True:
                data = conn.recv(1024)
                if not data:
                    break
                msg = data.decode("utf-8", errors="ignore")
                print("→", msg.strip())
                conn.sendall(f"ACK: {msg}".encode("utf-8"))


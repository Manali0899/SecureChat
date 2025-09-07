import React, { useState, useEffect } from "react";
import "./App.css";

function App() {
  const [ws, setWs] = useState(null);
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState("");
  const [username, setUsername] = useState("");

  useEffect(() => {
    const socket = new WebSocket("wss://securechat-backend.onrender.com"); // 👈 connect to Python server
    socket.onmessage = (event) => {
      setMessages((prev) => [...prev, event.data]);
    };
    setWs(socket);
    return () => socket.close();
  }, []);

  const sendMessage = () => {
    if (ws && input.trim() !== "" && username.trim() !== "") {
      const message = `[${username}] ${input}`;
      ws.send(message);
      setMessages((prev) => [...prev, `Me: ${input}`]);
      setInput("");
    }
  };

  return (
    <div className="chat-container">
      <h2>💬 SecureChat</h2>

      {!username ? (
        <div className="username-input">
          <input
            type="text"
            placeholder="Enter a username..."
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
        </div>
      ) : (
        <>
          <div className="chat-box">
            {messages.map((msg, i) => (
              <div key={i} className="chat-message">
                {msg}
              </div>
            ))}
          </div>

          <div className="chat-input">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Type a message..."
              onKeyDown={(e) => e.key === "Enter" && sendMessage()}
            />
            <button onClick={sendMessage}>Send</button>
          </div>
        </>
      )}
    </div>
  );
}

export default App;

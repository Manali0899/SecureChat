💬 SecureChat

A real-time chat application built with Python (WebSockets) and React. SecureChat allows multiple users to join, choose usernames, and exchange messages instantly in a clean, modern UI.

🚀 Live Demo

🔗 SecureChat Live Demo

👨‍💻 GitHub Repository

✨ Features

Real-time WebSocket messaging between multiple clients

Personalized usernames (Manali's SecureChat)

Clean, responsive chat UI (React + CSS)

Differentiated styling for my messages vs others’ messages

Modular backend with Python websockets for easy scalability

🛠️ Tech Stack

Frontend

React (Create React App)

WebSocket API

CSS (custom styling)

Backend

Python 3

websockets
 library

Deployment

Frontend → Vercel / Netlify

Backend → Render / Railway

📂 Project Structure
SecureChat/
 ├── server.py              # Python WebSocket backend
 ├── requirements.txt       # Python dependencies
 ├── securechat-frontend/   # React frontend
 │   ├── src/
 │   │   ├── App.js
 │   │   ├── App.css
 │   │   └── index.js
 │   ├── package.json
 │   └── ...

⚡ Getting Started (Local Setup)
1. Clone the Repo
git clone https://github.com/YOUR_USERNAME/SecureChat.git
cd SecureChat

2. Backend (Python)
pip install -r requirements.txt
python3 server.py


Server will run at: ws://localhost:8765

3. Frontend (React)
cd securechat-frontend
npm install
npm start


Frontend runs at: http://localhost:3000



🔮 Future Enhancements

End-to-end encryption

User authentication & login

Chat history persistence with a database

Online user list display

Timestamps per message

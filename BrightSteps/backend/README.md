# BrightSteps Backend API

Backend server for the BrightSteps autism-friendly games and progress tracking application.

## 🚀 Quick Start

### Prerequisites
- Node.js v18 or higher
- MongoDB (local or Atlas)
- OpenAI API key (for AI features)

### Installation

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file:
```bash
cp .env.example .env
```

3. Update `.env` with your credentials:
- `MONGO_URI`: Your MongoDB connection string
- `JWT_SECRET`: A secure random string
- `SMTP_*`: Your email service credentials (Gmail recommended)
- `OPENAI_API_KEY`: Your OpenAI API key

### Run the Server

Development mode with auto-reload:
```bash
npm run dev
```

Production mode:
```bash
npm start
```

The server will start on `http://localhost:5000`

## 📚 API Documentation

### Authentication

#### Register Parent
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "555-1234"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

#### Get Profile
```http
GET /api/auth/me
Authorization: Bearer <token>
```

### Children Management

#### Create Child Profile
```http
POST /api/children
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "name": "Alice",
  "age": 6,
  "preferredDifficulty": "easy",
  "avatar": <file>
}
```

#### Get All Children
```http
GET /api/children
Authorization: Bearer <token>
```

### Game Records

#### Save Game Session
```http
POST /api/games/record
Authorization: Bearer <token>
Content-Type: application/json

{
  "childId": "...",
  "gameName": "shape-match",
  "level": "easy",
  "startTime": "2025-11-01T10:00:00Z",
  "endTime": "2025-11-01T10:02:30Z",
  "correctCount": 5,
  "attemptCount": 6,
  "mistakes": 1
}
```

#### Get Progress
```http
GET /api/games/progress/:childId?period=week
Authorization: Bearer <token>
```

### Reminders

#### Create Reminder
```http
POST /api/reminders
Authorization: Bearer <token>
Content-Type: application/json

{
  "childId": "...",
  "type": "lunch",
  "time": "12:00",
  "title": "Lunch Time!",
  "message": "It's time for a healthy lunch",
  "daysOfWeek": [1, 2, 3, 4, 5]
}
```

### AI Features

#### Get Adaptive Recommendation
```http
POST /api/ai/adapt
Authorization: Bearer <token>
Content-Type: application/json

{
  "childId": "..."
}
```

#### Generate Song Lyrics
```http
POST /api/ai/song
Authorization: Bearer <token>
Content-Type: application/json

{
  "type": "breakfast",
  "childName": "Alice"
}
```

### Reports

#### Send Email Report
```http
POST /api/report/send
Authorization: Bearer <token>
Content-Type: application/json

{
  "childId": "..."
}
```

#### Preview Report
```http
GET /api/report/preview/:childId
Authorization: Bearer <token>
```

## 🗄️ Database Models

### Parent
- name, email, password
- caregiverEmails[]
- reportFrequency (daily/weekly/monthly)
- lastReportSent

### Child
- name, age, avatar (base64)
- parentId (ref)
- preferredDifficulty
- interests[], notes

### GameRecord
- childId (ref)
- gameName, level
- startTime, endTime, durationMs
- correctCount, attemptCount, mistakes
- score (auto-calculated)
- additionalData

### Reminder
- childId (ref)
- type, time, title, message
- songLyrics, audioFile
- enabled, daysOfWeek[]

## ⏰ Scheduled Tasks

The server runs two cron jobs:

1. **Daily Reports** (midnight): Checks report frequency and sends emails
2. **Reminders** (every minute): Checks for active reminders

## 🔒 Security

- Passwords hashed with bcrypt
- JWT authentication with 30-day expiration
- Protected routes require Bearer token
- CORS enabled for frontend origin
- Input validation on all endpoints

## 📧 Email Setup (Gmail)

1. Enable 2-factor authentication on your Gmail account
2. Generate an App Password:
   - Google Account → Security → 2-Step Verification → App passwords
3. Use the generated password in `.env` as `SMTP_PASS`

## 🤖 OpenAI Integration

The AI features require an OpenAI API key:
1. Sign up at https://platform.openai.com/
2. Create an API key
3. Add to `.env` as `OPENAI_API_KEY`

## 📝 Error Handling

All endpoints return consistent error responses:
```json
{
  "success": false,
  "message": "Error description"
}
```

Success responses:
```json
{
  "success": true,
  "data": { ... }
}
```

## 🛠️ Development

### Project Structure
```
backend/
├── config/          # Database, email, AI configuration
├── controllers/     # Request handlers
├── middleware/      # Auth, error handling
├── models/          # Mongoose schemas
├── routes/          # API routes
├── utils/           # Helper functions
└── server.js        # Entry point
```

### Adding New Features

1. Create model in `models/`
2. Create controller in `controllers/`
3. Create routes in `routes/`
4. Import routes in `server.js`

## 📊 Monitoring

Health check endpoint:
```http
GET /api/health
```

Returns server status and timestamp.

## 🐛 Troubleshooting

**MongoDB Connection Error:**
- Check `MONGO_URI` in `.env`
- Ensure MongoDB is running
- Check network/firewall settings

**Email Not Sending:**
- Verify SMTP credentials
- Check Gmail App Password
- Review email quota limits

**OpenAI Errors:**
- Verify API key is valid
- Check account credit/quota
- Review API usage limits

## 📄 License

MIT License - see LICENSE file for details


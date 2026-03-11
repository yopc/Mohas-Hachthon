# BrightSteps - Complete Setup Guide

## 📋 Overview

BrightSteps is a full-stack application for autism-friendly educational games with progress tracking, AI-powered recommendations, and parent dashboards.

## 🏗️ Architecture

- **Backend**: Node.js + Express + MongoDB + OpenAI
- **Frontend**: React + Vite + Zustand + TailwindCSS
- **Features**: 3 interactive games, progress tracking, email reports, AI insights

---

## 🚀 Backend Setup

### 1. Navigate to Backend Directory
```bash
cd backend
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Environment Configuration

Create `.env` file:
```bash
cp .env.example .env
```

Update `.env` with your credentials:
```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/brightsteps
# Or use MongoDB Atlas:
# MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/brightsteps

JWT_SECRET=your_super_secret_jwt_key_here

# Gmail SMTP (recommended)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_gmail_app_password

# OpenAI (optional for AI features)
OPENAI_API_KEY=sk-your_openai_api_key

FRONTEND_URL=http://localhost:5173
NODE_ENV=development
```

### 4. MongoDB Setup

**Option A: Local MongoDB**
```bash
# Install MongoDB locally
# macOS:
brew install mongodb-community
brew services start mongodb-community

# Ubuntu:
sudo apt-get install mongodb
sudo systemctl start mongodb

# Windows: Download from mongodb.com
```

**Option B: MongoDB Atlas (Cloud)**
1. Go to https://www.mongodb.com/cloud/atlas
2. Create free account
3. Create cluster
4. Get connection string
5. Add to `MONGO_URI` in `.env`

### 5. Gmail App Password (for Email Reports)

1. Enable 2-Factor Authentication on Gmail
2. Go to Google Account → Security → 2-Step Verification
3. Scroll to "App passwords"
4. Generate password for "Mail"
5. Copy password to `SMTP_PASS` in `.env`

### 6. OpenAI API Key (Optional)

1. Go to https://platform.openai.com/
2. Create account / Sign in
3. Go to API Keys
4. Create new secret key
5. Copy to `OPENAI_API_KEY` in `.env`

### 7. Start Backend Server

Development mode:
```bash
npm run dev
```

Production mode:
```bash
npm start
```

Server will run on `http://localhost:5000`

### 8. Test Backend

```bash
curl http://localhost:5000/api/health
```

Should return:
```json
{
  "success": true,
  "message": "BrightSteps API is running",
  "timestamp": "..."
}
```

---

## 🎨 Frontend Setup

### 1. Navigate to Frontend Directory
```bash
cd frontend
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Environment Configuration

The `.env` file is usually blocked, but you can set:
```env
VITE_API_URL=http://localhost:5000/api
```

Or the default in `axiosInstance.js` will be used.

### 4. Start Frontend Development Server

```bash
npm run dev
```

Frontend will run on `http://localhost:5173`

### 5. Build for Production

```bash
npm run build
```

---

## 🎮 Application Flow

### First Time Setup

1. **Start Backend** → `cd backend && npm run dev`
2. **Start Frontend** → `cd frontend && npm run dev`
3. **Open Browser** → `http://localhost:5173`
4. **Register** → Create parent account
5. **Add Child** → Create first child profile
6. **Play Games** → Start learning!

### Parent Features

- **Dashboard**: View progress, charts, statistics
- **Child Management**: Add/edit multiple children
- **Reminders**: Set meal and activity reminders
- **Email Reports**: Automated progress reports
- **AI Insights**: Personalized recommendations

### Child Features

- **Shape Matching**: Match shapes and colors (3 levels)
- **Sound Matching**: Identify animal sounds (3 levels)
- **Memory Puzzle**: Find matching pairs (3 grid sizes)

---

## 📊 API Endpoints

### Authentication
```
POST /api/auth/register  - Register parent
POST /api/auth/login     - Login parent
GET  /api/auth/me        - Get profile
PUT  /api/auth/me        - Update profile
```

### Children
```
POST   /api/children     - Create child
GET    /api/children     - Get all children
GET    /api/children/:id - Get child
PUT    /api/children/:id - Update child
DELETE /api/children/:id - Delete child
```

### Games
```
POST /api/games/record           - Save game session
GET  /api/games/records/:childId - Get game records
GET  /api/games/progress/:childId - Get progress stats
GET  /api/games/daily-stats/:childId - Get daily stats
```

### AI
```
POST /api/ai/adapt      - Get difficulty recommendation
POST /api/ai/song       - Generate song lyrics
POST /api/ai/motivate   - Generate motivation message
POST /api/ai/parent-tip - Get parent guidance tip
```

### Reports
```
POST /api/report/send         - Send email report
GET  /api/report/preview/:childId - Preview report
```

---

## 🎯 Game Details

### Shape & Color Matching
- **Easy**: 2 shapes
- **Medium**: 4 shapes
- **Hard**: 6 shapes
- Tracks: time, accuracy, score

### Animal Sound Game
- **Easy**: 2 animals
- **Medium**: 4 animals
- **Hard**: 6 animals
- Features: audio playback, instant feedback

### Memory Puzzle
- **Easy**: 2x2 grid (2 pairs)
- **Medium**: 4x2 grid (4 pairs)
- **Hard**: 4x3 grid (6 pairs)
- Features: flip animations, move counting

---

## 🔧 Troubleshooting

### Backend Won't Start

**MongoDB Connection Error:**
```bash
# Check if MongoDB is running
# Local:
sudo systemctl status mongodb
# Or:
brew services list

# Check connection string in .env
```

**Port Already in Use:**
```bash
# Change PORT in .env to different port
PORT=5001
```

### Frontend Won't Connect to Backend

**CORS Error:**
- Check `FRONTEND_URL` in backend `.env`
- Ensure frontend URL matches

**API Not Found:**
- Verify backend is running
- Check `VITE_API_URL` points to correct backend

### Email Not Sending

**SMTP Error:**
- Use Gmail App Password (not regular password)
- Enable "Less Secure Apps" if needed
- Check firewall isn't blocking port 587

### OpenAI Errors

**Invalid API Key:**
- Verify key starts with `sk-`
- Check you have credits on OpenAI account
- API key is active (not revoked)

---

## 📦 Production Deployment

### Backend (e.g., Heroku, Railway, Render)

1. Set environment variables
2. Ensure MongoDB is accessible
3. Set `NODE_ENV=production`
4. Deploy:
```bash
git push heroku main
# Or use platform's deployment method
```

### Frontend (e.g., Vercel, Netlify)

1. Build:
```bash
npm run build
```

2. Set `VITE_API_URL` to production backend
3. Deploy `dist/` folder

---

## 🔐 Security Checklist

- [ ] Change `JWT_SECRET` to strong random string
- [ ] Use environment variables (never commit `.env`)
- [ ] Use HTTPS in production
- [ ] Enable CORS only for your frontend domain
- [ ] Set strong MongoDB password
- [ ] Keep dependencies updated
- [ ] Use Gmail App Passwords (not regular password)
- [ ] Limit OpenAI API usage/budget

---

## 📱 Tech Stack Summary

### Backend
- Express.js - Web framework
- MongoDB - Database
- Mongoose - ODM
- JWT - Authentication
- bcrypt - Password hashing
- Nodemailer - Email sending
- node-cron - Scheduled tasks
- OpenAI - AI features
- Multer - File uploads

### Frontend
- React 18 - UI library
- Vite - Build tool
- React Router - Routing
- Zustand - State management
- Axios - HTTP client
- Recharts - Charts
- Framer Motion - Animations
- Tone.js - Audio
- TailwindCSS - Styling
- Lucide React - Icons

---

## 📄 File Structure

```
BrightSteps/
├── backend/
│   ├── config/         # DB, email, AI config
│   ├── controllers/    # Business logic
│   ├── middleware/     # Auth, errors
│   ├── models/         # MongoDB schemas
│   ├── routes/         # API routes
│   ├── utils/          # Helpers
│   ├── server.js       # Entry point
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── api/        # API client
│   │   ├── components/ # Reusable components
│   │   ├── pages/      # Route pages
│   │   ├── store/      # Zustand store
│   │   ├── utils/      # Utilities
│   │   ├── App.jsx     # Main app
│   │   └── main.jsx    # Entry
│   └── package.json
│
└── README.md
```

---

## 🆘 Getting Help

### Common Issues

1. **"Cannot find module"** → Run `npm install`
2. **"EADDRINUSE"** → Port in use, change PORT
3. **"401 Unauthorized"** → Check JWT token
4. **"CORS error"** → Check CORS settings
5. **"Module not found"** → Check import paths

### Resources

- MongoDB Docs: https://docs.mongodb.com/
- Express Docs: https://expressjs.com/
- React Docs: https://react.dev/
- OpenAI Docs: https://platform.openai.com/docs

---

## ✅ Quick Start Checklist

Backend:
- [ ] MongoDB installed/configured
- [ ] `.env` file created with all variables
- [ ] Dependencies installed (`npm install`)
- [ ] Server starts successfully (`npm run dev`)
- [ ] Health check passes

Frontend:
- [ ] Dependencies installed (`npm install`)
- [ ] Backend URL configured
- [ ] Dev server starts (`npm run dev`)
- [ ] Can access login page
- [ ] Can register account

Full Test:
- [ ] Register parent account
- [ ] Add child profile
- [ ] Play a game
- [ ] View dashboard
- [ ] Check progress charts

---

## 🎉 You're All Set!

Your BrightSteps application should now be running. Enjoy building an inclusive learning experience!

For issues or questions, check the troubleshooting section or review the code comments.


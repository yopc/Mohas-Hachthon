# 🌟 BrightSteps - Autism-Friendly Educational Platform

A complete full-stack web application supporting **interactive autism-friendly games**, **progress tracking**, **parent dashboard**, **email reporting**, **meal reminders**, and **AI personalization**.

![BrightSteps](https://img.shields.io/badge/BrightSteps-Educational%20Platform-purple?style=for-the-badge)
![React](https://img.shields.io/badge/React-18-blue?style=for-the-badge&logo=react)
![Node.js](https://img.shields.io/badge/Node.js-18+-green?style=for-the-badge&logo=node.js)
![MongoDB](https://img.shields.io/badge/MongoDB-Database-brightgreen?style=for-the-badge&logo=mongodb)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Games](#games)
- [API Documentation](#api-documentation)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

BrightSteps is designed to provide an inclusive, calming, and accessible learning experience for children with autism. The platform features:

- **3 Interactive Games** with multiple difficulty levels
- **Real-time Progress Tracking** with detailed analytics
- **Parent Dashboard** with charts and insights
- **AI-Powered Recommendations** for adaptive difficulty
- **Automated Email Reports** to caregivers
- **Meal & Activity Reminders** with fun songs

---

## ✨ Features

### 🎮 Child Features

#### **Interactive Games**
- **Shape & Color Matching**: Match shapes with visual feedback (Easy/Medium/Hard)
- **Animal Sound Game**: Listen and identify animal sounds
- **Memory Puzzle**: Classic flip-to-match with multiple grid sizes

#### **Child-Friendly Design**
- Large, colorful buttons
- Calming color schemes
- Positive audio feedback
- Voice instructions (text-to-speech)
- Smooth animations
- Clear visual cues

### 👨‍👩‍👧 Parent Features

#### **Dashboard Analytics**
- Daily, weekly, and monthly progress views
- Interactive charts (line, bar)
- Game-by-game performance breakdown
- Accuracy and time tracking
- Top performing games

#### **Child Management**
- Create multiple child profiles
- Set preferred difficulty levels
- Upload avatars (stored as base64)
- Track individual progress

#### **Email Reports**
- Automated scheduled reports (daily/weekly/monthly)
- HTML-formatted with charts
- AI-generated insights and tips
- Sent to multiple caregiver emails

#### **AI Integration**
- Adaptive difficulty recommendations
- Personalized parent guidance tips
- Motivational messages for children
- Custom song lyrics generation

#### **Reminders**
- Meal time reminders (breakfast/lunch/dinner)
- Custom activity reminders
- Scheduled with node-cron
- Fun songs and animations

---

## 🛠️ Tech Stack

### Backend
```
Node.js v18+
Express.js
MongoDB + Mongoose
JWT Authentication
bcrypt (password hashing)
Nodemailer (email reports)
node-cron (scheduled tasks)
OpenAI API (AI features)
Multer (image uploads as base64)
```

### Frontend
```
React 18
Vite (build tool)
Zustand (state management)
React Router (routing)
Axios (API calls)
Recharts (charts/graphs)
Framer Motion (animations)
Tone.js (sound effects)
TailwindCSS (styling)
Lucide React (icons)
```

---

## 🚀 Quick Start

### Prerequisites
- Node.js v18+
- MongoDB (local or Atlas)
- Gmail account (for email reports)
- OpenAI API key (optional, for AI features)

### Installation

**1. Clone the repository**
```bash
git clone <your-repo-url>
cd BrightSteps
```

**2. Backend Setup**
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your credentials
npm run dev
```

**3. Frontend Setup**
```bash
cd frontend
npm install
npm run dev
```

**4. Open in browser**
```
http://localhost:5173
```

### Default Ports
- **Backend**: http://localhost:5000
- **Frontend**: http://localhost:5173

---

## 📁 Project Structure

```
BrightSteps/
├── backend/
│   ├── config/
│   │   ├── db.js              # MongoDB connection
│   │   ├── mailer.js          # Email configuration
│   │   ├── openai.js          # OpenAI integration
│   │   └── multer.js          # File upload (base64)
│   ├── controllers/
│   │   ├── authController.js      # Authentication logic
│   │   ├── childController.js     # Child management
│   │   ├── gameController.js      # Game records
│   │   ├── reminderController.js  # Reminders
│   │   ├── aiController.js        # AI features
│   │   └── emailController.js     # Email reports
│   ├── middleware/
│   │   ├── auth.js            # JWT verification
│   │   └── errorHandler.js    # Error handling
│   ├── models/
│   │   ├── Parent.js          # Parent schema
│   │   ├── Child.js           # Child schema
│   │   ├── GameRecord.js      # Game session schema
│   │   └── Reminder.js        # Reminder schema
│   ├── routes/
│   │   ├── authRoutes.js
│   │   ├── childRoutes.js
│   │   ├── gameRoutes.js
│   │   ├── reminderRoutes.js
│   │   ├── reportRoutes.js
│   │   └── aiRoutes.js
│   ├── utils/
│   │   ├── calculateScore.js  # Score calculation
│   │   ├── emailTemplate.js   # HTML email template
│   │   └── cronJobs.js        # Scheduled tasks
│   ├── server.js              # Entry point
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── api/
│   │   │   └── axiosInstance.js   # API client
│   │   ├── components/
│   │   │   ├── Navbar.jsx         # Navigation
│   │   │   ├── StatsCard.jsx      # Statistics display
│   │   │   └── ChartCard.jsx      # Chart component
│   │   ├── pages/
│   │   │   ├── Login.jsx          # Login page
│   │   │   ├── Register.jsx       # Registration
│   │   │   ├── ChildSelect.jsx    # Child selection
│   │   │   ├── GameLauncher.jsx   # Game menu
│   │   │   ├── ShapeMatch.jsx     # Shape game
│   │   │   ├── SoundMatch.jsx     # Sound game
│   │   │   ├── MemoryGame.jsx     # Memory game
│   │   │   └── ParentDashboard.jsx # Parent dashboard
│   │   ├── store/
│   │   │   └── useAppStore.js     # Zustand store
│   │   ├── utils/
│   │   │   ├── timeUtils.js       # Time formatting
│   │   │   └── soundUtils.js      # Sound effects
│   │   ├── App.jsx                # Main app
│   │   └── main.jsx               # Entry point
│   └── package.json
│
├── PROJECT_SETUP.md       # Detailed setup guide
├── README.md              # This file
└── .gitignore
```

---

## 🎮 Games

### 1. Shape & Color Matching 🔴

Match shapes and colors with three difficulty levels:
- **Easy**: 2 shapes
- **Medium**: 4 shapes
- **Hard**: 6 shapes

**Tracks**: Time, accuracy, score, mistakes

### 2. Animal Sound Game 🔊

Listen to sounds and identify the correct animal:
- **Easy**: 2 animals
- **Medium**: 4 animals
- **Hard**: 6 animals

**Features**: Audio playback, instant feedback, animal emojis

### 3. Memory Puzzle 🧠

Classic flip-to-match card game:
- **Easy**: 2×2 grid (2 pairs)
- **Medium**: 4×2 grid (4 pairs)
- **Hard**: 4×3 grid (6 pairs)

**Features**: Flip animations, move counter, completion time

---

## 📊 API Documentation

### Authentication
```http
POST   /api/auth/register    # Register parent
POST   /api/auth/login       # Login
GET    /api/auth/me          # Get profile
PUT    /api/auth/me          # Update profile
```

### Children
```http
POST   /api/children         # Create child profile
GET    /api/children         # Get all children
GET    /api/children/:id     # Get single child
PUT    /api/children/:id     # Update child
DELETE /api/children/:id     # Delete child
```

### Games
```http
POST   /api/games/record              # Save game session
GET    /api/games/records/:childId    # Get game records
GET    /api/games/progress/:childId   # Get progress stats
GET    /api/games/daily-stats/:childId # Get daily statistics
```

### AI Features
```http
POST   /api/ai/adapt         # Get difficulty recommendation
POST   /api/ai/song          # Generate song lyrics
POST   /api/ai/motivate      # Generate motivation message
POST   /api/ai/parent-tip    # Get parent guidance
```

### Reports
```http
POST   /api/report/send      # Send email report
GET    /api/report/preview/:childId # Preview report
```

### Reminders
```http
POST   /api/reminders        # Create reminder
GET    /api/reminders/:childId # Get reminders
PUT    /api/reminders/:id    # Update reminder
DELETE /api/reminders/:id    # Delete reminder
```

---

## 🔐 Environment Variables

### Backend (.env)
```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/brightsteps
JWT_SECRET=your_secret_key
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_gmail_app_password
OPENAI_API_KEY=sk-your_openai_key
FRONTEND_URL=http://localhost:5173
```

### Frontend (.env)
```env
VITE_API_URL=http://localhost:5000/api
```

---

## 🎨 Key Features Implementation

### Image Storage (Base64)
All images (child avatars, etc.) are stored as base64 strings in MongoDB:
```javascript
const imgUrl = `data:${mimeType};base64,${base64}`;
// Use directly in <img src={imgUrl} />
```

### Score Calculation
```javascript
score = (correctCount / attemptCount) * 100 + levelBonus - (mistakes * 2)
```

### Scheduled Reports
Using node-cron for automated email sending:
- Daily: 00:00
- Weekly: Every 7 days
- Monthly: Every 30 days

### AI Recommendations
OpenAI analyzes last 7 game sessions to recommend difficulty level and provide tips.

---

## 🧪 Testing

### Backend
```bash
cd backend
npm test
```

### Frontend
```bash
cd frontend
npm run lint
```

### Manual Testing Flow
1. Register parent account
2. Create child profile
3. Play each game (all difficulty levels)
4. Check dashboard for progress
5. Trigger email report
6. Test AI recommendations

---

## 📱 Responsive Design

- **Mobile**: Optimized for touch (large buttons)
- **Tablet**: Adjusted grid layouts
- **Desktop**: Full dashboard experience

---

## ♿ Accessibility Features

- High contrast colors
- Large touch targets
- Clear visual feedback
- Audio cues and voice instructions
- Simple navigation
- Calming animations
- Autism-friendly design principles

---

## 🔒 Security

- Passwords hashed with bcrypt
- JWT authentication (30-day expiration)
- Protected API routes
- CORS configured
- Input validation
- MongoDB injection prevention

---

## 📈 Future Enhancements

- [ ] More games (counting, letters, etc.)
- [ ] Social features (parent community)
- [ ] Therapist accounts
- [ ] Mobile app (React Native)
- [ ] Offline mode
- [ ] Multi-language support
- [ ] Custom game creation by parents
- [ ] Video call integration

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👏 Acknowledgments

- Inspired by the need for inclusive educational tools
- Built with love for children with autism
- Thanks to all contributors and supporters

---

## 📞 Support

For setup help, see [PROJECT_SETUP.md](PROJECT_SETUP.md)

For questions or issues:
- Open an issue on GitHub
- Email: support@brightsteps.com

---

## 🌟 Star this repo if you find it helpful!

Made with ❤️ for inclusive education

---

## 📸 Screenshots

### Login Page
Beautiful gradient background with form validation

### Child Selection
Visual child profiles with avatars

### Game Interface
Large, colorful, autism-friendly design

### Parent Dashboard
Comprehensive analytics with interactive charts

### Progress Reports
Automated HTML email reports with AI insights

---

**BrightSteps** - Making learning accessible and fun for every child! 🌟


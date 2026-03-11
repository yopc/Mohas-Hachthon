# BrightSteps Frontend

React-based frontend application for BrightSteps - an autism-friendly educational games platform.

## 🚀 Quick Start

### Prerequisites
- Node.js v18 or higher
- Backend API running (see `backend/README.md`)

### Installation

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file:
```bash
cp .env.example .env
```

3. Update `.env` with your backend API URL:
```
VITE_API_URL=http://localhost:5000/api
```

### Run the Application

Development mode with hot reload:
```bash
npm run dev
```

The app will start on `http://localhost:5173`

Build for production:
```bash
npm run build
```

Preview production build:
```bash
npm run preview
```

## 📱 Application Structure

### Pages

#### Authentication
- **Login** (`/login`) - Parent login
- **Register** (`/register`) - Parent registration

#### Parent Features
- **Dashboard** (`/dashboard`) - Progress tracking and analytics
- **Child Select** (`/children`) - Select which child to play

#### Child Features
- **Game Launcher** (`/games`) - Choose a game to play
- **Shape Match** (`/games/shape-match`) - Match shapes and colors
- **Sound Match** (`/games/sound-match`) - Match animal sounds
- **Memory Puzzle** (`/games/memory-puzzle`) - Classic memory card game

### Key Features

#### 🎮 Interactive Games
- **Shape & Color Matching**: Match shapes by appearance with 3 difficulty levels
- **Animal Sound Game**: Listen and identify animal sounds
- **Memory Puzzle**: Find matching pairs with visual animations

#### 📊 Progress Tracking
- Real-time score tracking
- Accuracy calculations
- Time measurements
- Detailed statistics per game

#### 🎨 Child-Friendly Design
- Large, colorful buttons
- Clear visual feedback
- Calming color schemes
- Smooth animations
- Voice instructions (text-to-speech)

#### 👨‍👩‍👧 Parent Dashboard
- View progress over time
- Compare game performance
- Export reports
- Manage multiple children
- AI-powered insights

## 🛠️ Tech Stack

- **React 18** - UI framework
- **React Router** - Navigation
- **Zustand** - State management
- **Axios** - API calls
- **Recharts** - Data visualization
- **Framer Motion** - Animations
- **Tone.js** - Sound effects
- **TailwindCSS** - Styling
- **Lucide React** - Icons

## 📁 Project Structure

```
frontend/
├── src/
│   ├── api/
│   │   └── axiosInstance.js      # API configuration
│   ├── components/
│   │   ├── Navbar.jsx            # Navigation bar
│   │   ├── StatsCard.jsx         # Statistics display
│   │   └── ChartCard.jsx         # Chart components
│   ├── pages/
│   │   ├── Login.jsx             # Login page
│   │   ├── Register.jsx          # Registration
│   │   ├── ChildSelect.jsx       # Child selection
│   │   ├── GameLauncher.jsx      # Game menu
│   │   ├── ShapeMatch.jsx        # Shape game
│   │   ├── SoundMatch.jsx        # Sound game
│   │   ├── MemoryGame.jsx        # Memory game
│   │   └── ParentDashboard.jsx   # Parent dashboard
│   ├── store/
│   │   └── useAppStore.js        # Zustand store
│   ├── utils/
│   │   ├── timeUtils.js          # Time formatting
│   │   └── soundUtils.js         # Sound effects
│   ├── App.jsx                   # Main app component
│   └── main.jsx                  # Entry point
├── package.json
└── vite.config.js
```

## 🎮 Game Features

### Shape & Color Matching
- 3 difficulty levels (2, 4, 6 shapes)
- Visual and audio feedback
- Score tracking
- Time measurement

### Animal Sound Game
- Interactive sound playback
- Multiple animals per level
- Difficulty progression
- Immediate feedback

### Memory Puzzle
- Multiple grid sizes (2x2, 4x2, 4x3)
- Flip animations
- Match detection
- Move counting

## 🔐 Authentication Flow

1. Parent registers with email/password
2. JWT token stored in localStorage
3. Protected routes require authentication
4. Auto-redirect to login if not authenticated

## 📊 State Management

Using Zustand for global state:
- Authentication state
- Children profiles
- Current child selection
- Game progress
- AI recommendations
- Reminders

## 🎨 Styling

TailwindCSS for styling with:
- Custom color palette (purple/blue theme)
- Responsive design
- Smooth transitions
- Accessible components

## 🔊 Sound System

Using Tone.js for sound effects:
- Success sounds
- Error sounds
- Celebration sounds
- Animal sounds
- Background music (optional)

Using Web Speech API for:
- Text-to-speech instructions
- Game narration

## 📈 Progress Tracking

Game sessions save:
- Start/end times
- Correct answers
- Total attempts
- Mistakes made
- Calculated score
- Difficulty level

## 🤖 AI Integration

- Adaptive difficulty recommendations
- Personalized tips for parents
- Motivational messages for children
- Song lyrics generation

## 🌐 API Integration

All API calls go through `axiosInstance`:
- Automatic token injection
- Error handling
- Request/response interceptors

## 🎯 Accessibility Features

- Large touch targets
- High contrast colors
- Clear visual feedback
- Audio cues
- Simple navigation
- Calm animations

## 🐛 Troubleshooting

**API Connection Error:**
- Check backend is running
- Verify VITE_API_URL in `.env`
- Check CORS settings

**Authentication Issues:**
- Clear localStorage
- Check token validity
- Verify backend JWT settings

**Sound Not Playing:**
- Enable autoplay in browser
- Click anywhere to start audio context
- Check browser audio permissions

## 📄 License

MIT License - see LICENSE file for details

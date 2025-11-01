# ⚡ BrightSteps - Quick Start Guide

Get up and running in 5 minutes!

---

## 🎯 What You'll Need

- [ ] Node.js 18+ installed
- [ ] MongoDB running (local or Atlas)
- [ ] Gmail account for email features
- [ ] 10 minutes of your time

---

## 🚀 3-Step Setup

### Step 1: Backend Setup (2 minutes)

```bash
# Terminal 1
cd backend
npm install
```

Create `backend/.env`:
```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/brightsteps
JWT_SECRET=brightsteps_secret_2025
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_gmail_app_password
OPENAI_API_KEY=sk-your_key_optional
FRONTEND_URL=http://localhost:5173
```

Start backend:
```bash
npm run dev
```

✅ You should see: `🚀 Server running on port 5000`

---

### Step 2: Frontend Setup (2 minutes)

```bash
# Terminal 2 (new terminal)
cd frontend
npm install
npm run dev
```

✅ You should see: `Local: http://localhost:5173`

---

### Step 3: Try It Out! (5 minutes)

1. Open http://localhost:5173
2. Click "Register here"
3. Create parent account
4. Add a child profile
5. Click "Child View" → Select your child
6. Play a game!
7. Go back to "Parent Dashboard" → See progress

---

## 🎮 Quick Tour

### For Parents

**Dashboard** (`/dashboard`)
- View all your children's progress
- See charts and statistics
- Manage children profiles
- Configure email reports
- Get AI recommendations

**Add a Child**
1. Dashboard → "Children" tab
2. Click "Add Child"
3. Enter name, age, starting difficulty
4. (Optional) Upload avatar
5. Click "Add Child"

**View Progress**
1. Dashboard → "Progress Overview" tab
2. Select a child
3. Choose time period (day/week/month)
4. View charts and stats

### For Children

**Play Games**
1. Home → Select your profile
2. Choose a game
3. Select difficulty
4. Start playing!
5. Get instant feedback
6. See your score!

**Games Available:**
- 🔴 Shape & Color Matching
- 🔊 Animal Sound Game
- 🧠 Memory Puzzle

---

## 🔧 Quick Fixes

### "Can't connect to MongoDB"
```bash
# Install MongoDB locally:
# Mac:
brew install mongodb-community
brew services start mongodb-community

# Ubuntu:
sudo apt-get install mongodb
sudo systemctl start mongodb

# Or use MongoDB Atlas (free cloud):
# https://www.mongodb.com/cloud/atlas
```

### "Backend won't start"
```bash
# Check if port 5000 is free
# Change PORT in backend/.env if needed
PORT=5001
```

### "Frontend can't reach backend"
```bash
# Make sure backend is running on port 5000
# Check backend terminal for errors
curl http://localhost:5000/api/health
```

### "Gmail emails not sending"
```bash
# You need a Gmail App Password (not regular password):
# 1. Go to Google Account → Security
# 2. Enable 2-Step Verification
# 3. Create App Password for "Mail"
# 4. Use that password in SMTP_PASS
```

---

## 📋 Quick Commands

### Backend
```bash
cd backend
npm run dev      # Start development server
npm start        # Start production server
```

### Frontend
```bash
cd frontend
npm run dev      # Start development server
npm run build    # Build for production
npm run preview  # Preview production build
```

---

## 🎯 Test Everything Works

Run this checklist:

1. ✅ Backend starts without errors
2. ✅ Frontend starts and opens in browser
3. ✅ Can register a new parent account
4. ✅ Can login with credentials
5. ✅ Can create a child profile
6. ✅ Can select child and see game menu
7. ✅ Can play a game and see score
8. ✅ Can view progress in dashboard
9. ✅ Charts show data

If all checks pass → You're ready to go! 🎉

---

## 🆘 Still Having Issues?

1. Check both terminals for error messages
2. Read the error message carefully
3. See [PROJECT_SETUP.md](PROJECT_SETUP.md) for detailed help
4. Check [README.md](README.md) for full documentation

---

## 🎨 What's Next?

### Customize Your Experience

**Add More Children**
- Dashboard → Children tab → Add Child

**Try Different Games**
- Each game has 3 difficulty levels
- All progress is tracked automatically

**View AI Insights** (if you added OpenAI key)
- Dashboard → AI Insights tab
- Get personalized recommendations

**Setup Email Reports**
- Dashboard → Email Reports tab
- Add caregiver emails
- Choose report frequency

**Create Reminders**
- Dashboard → Reminders tab
- Set meal times
- Add custom reminders

---

## 💡 Pro Tips

1. **Start with Easy difficulty** for new children
2. **Play regularly** - daily sessions show better progress
3. **Check dashboard weekly** to see trends
4. **Use AI recommendations** to adjust difficulty
5. **Add multiple caregivers** for progress updates
6. **Celebrate small wins!** 🎉

---

## 📱 Access Points

Once running:

- **Frontend**: http://localhost:5173
- **Backend**: http://localhost:5000
- **Health Check**: http://localhost:5000/api/health
- **API Docs**: See [README.md](README.md#api-documentation)

---

## 🎉 You're All Set!

**Enjoy using BrightSteps!**

The platform is designed to be:
- ✨ Simple to use
- 🎨 Visually appealing
- ♿ Accessible for all
- 📊 Data-driven
- 🤖 AI-enhanced

---

**Questions?** Check the troubleshooting section above or see the full docs.

**Happy Learning!** 🌟


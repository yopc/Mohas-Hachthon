import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { useAppStore } from './store/useAppStore';

// Pages
import Login from './pages/Login';
import Register from './pages/Register';
import ChildSelect from './pages/ChildSelect';
import GameLauncher from './pages/GameLauncher';
import ShapeMatch from './pages/ShapeMatch';
import SoundMatch from './pages/SoundMatch';
import MemoryGame from './pages/MemoryGame';
import ParentDashboard from './pages/ParentDashboard';

// Protected Route Component
const ProtectedRoute = ({ children }) => {
  const isAuthenticated = useAppStore((state) => state.isAuthenticated);
  return isAuthenticated ? children : <Navigate to="/login" />;
};

const App = () => {
  return (
    <Router>
      <Routes>
        {/* Public Routes */}
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        
        {/* Protected Routes */}
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <ParentDashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/children"
          element={
            <ProtectedRoute>
              <ChildSelect />
            </ProtectedRoute>
          }
        />
        <Route
          path="/games"
          element={
            <ProtectedRoute>
              <GameLauncher />
            </ProtectedRoute>
          }
        />
        <Route
          path="/games/shape-match"
          element={
            <ProtectedRoute>
              <ShapeMatch />
            </ProtectedRoute>
          }
        />
        <Route
          path="/games/sound-match"
          element={
            <ProtectedRoute>
              <SoundMatch />
            </ProtectedRoute>
          }
        />
        <Route
          path="/games/memory-puzzle"
          element={
            <ProtectedRoute>
              <MemoryGame />
            </ProtectedRoute>
          }
        />
        
        {/* Default Route */}
        <Route path="/" element={<Navigate to="/children" />} />
        <Route path="*" element={<Navigate to="/children" />} />
      </Routes>
    </Router>
  );
};

export default App;

import { useNavigate } from 'react-router-dom';
import { useAppStore } from '../store/useAppStore';
import { LogOut, User } from 'lucide-react';

const Navbar = () => {
  const navigate = useNavigate();
  const { parent, logout } = useAppStore();
  
  const handleLogout = () => {
    logout();
    navigate('/login');
  };
  
  return (
    <nav className="bg-white shadow-md">
      <div className="max-w-7xl mx-auto px-6 py-4">
        <div className="flex justify-between items-center">
          <div className="flex items-center gap-3">
            <h1 className="text-2xl font-bold text-purple-600">🌟 BrightSteps</h1>
            <span className="text-gray-400">|</span>
            <span className="text-gray-600">Parent Dashboard</span>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2 px-4 py-2 bg-purple-50 rounded-lg">
              <User className="w-5 h-5 text-purple-600" />
              <span className="font-medium text-gray-800">{parent?.name}</span>
            </div>
            
            <button
              onClick={() => navigate('/children')}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition font-medium"
            >
              Child View
            </button>
            
            <button
              onClick={handleLogout}
              className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition flex items-center gap-2 font-medium"
            >
              <LogOut className="w-5 h-5" />
              Logout
            </button>
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navbar;


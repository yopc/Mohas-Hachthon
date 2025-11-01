import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppStore } from '../store/useAppStore';
import { Plus, User, LogOut } from 'lucide-react';
import { motion } from 'framer-motion';

const ChildSelect = () => {
  const navigate = useNavigate();
  const { children, fetchChildren, setCurrentChild, logout, parent } = useAppStore();
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  
  useEffect(() => {
    loadChildren();
  }, []);
  
  const loadChildren = async () => {
    try {
      await fetchChildren();
    } catch (error) {
      console.error('Failed to load children:', error);
    } finally {
      setLoading(false);
    }
  };
  
  const handleSelectChild = (child) => {
    setCurrentChild(child);
    navigate('/games');
  };
  
  const handleLogout = () => {
    logout();
    navigate('/login');
  };
  
  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-100 via-blue-100 to-pink-100 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-16 w-16 border-b-4 border-purple-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }
  
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-blue-100 to-pink-100 p-6">
      {/* Header */}
      <div className="max-w-6xl mx-auto mb-8">
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-4xl font-bold text-purple-600 mb-2">🌟 BrightSteps</h1>
            <p className="text-gray-600">Welcome back, {parent?.name}!</p>
          </div>
          <div className="flex gap-3">
            <button
              onClick={() => navigate('/dashboard')}
              className="px-6 py-3 bg-white text-purple-600 rounded-lg font-semibold hover:bg-purple-50 transition"
            >
              Parent Dashboard
            </button>
            <button
              onClick={handleLogout}
              className="px-6 py-3 bg-red-500 text-white rounded-lg font-semibold hover:bg-red-600 transition flex items-center gap-2"
            >
              <LogOut className="w-5 h-5" />
              Logout
            </button>
          </div>
        </div>
      </div>
      
      {/* Child Selection */}
      <div className="max-w-6xl mx-auto">
        <h2 className="text-2xl font-semibold text-gray-800 mb-6">
          Who's learning today?
        </h2>
        
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Existing Children */}
          {children.map((child, index) => (
            <motion.div
              key={child._id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
            >
              <button
                onClick={() => handleSelectChild(child)}
                className="w-full bg-white rounded-2xl shadow-lg p-8 hover:shadow-xl transition-all hover:scale-105 group"
              >
                <div className="flex flex-col items-center">
                  {child.avatar ? (
                    <img
                      src={child.avatar}
                      alt={child.name}
                      className="w-32 h-32 rounded-full object-cover mb-4 border-4 border-purple-200 group-hover:border-purple-400 transition"
                    />
                  ) : (
                    <div className="w-32 h-32 rounded-full bg-gradient-to-br from-purple-400 to-blue-400 flex items-center justify-center mb-4 border-4 border-purple-200 group-hover:border-purple-400 transition">
                      <User className="w-16 h-16 text-white" />
                    </div>
                  )}
                  <h3 className="text-2xl font-bold text-gray-800 mb-1">{child.name}</h3>
                  <p className="text-gray-600">Age {child.age}</p>
                  <div className="mt-4 px-4 py-2 bg-purple-100 rounded-full text-sm text-purple-700 font-medium">
                    Click to start playing!
                  </div>
                </div>
              </button>
            </motion.div>
          ))}
          
          {/* Add New Child */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: children.length * 0.1 }}
          >
            <button
              onClick={() => navigate('/dashboard?tab=children')}
              className="w-full bg-white rounded-2xl shadow-lg p-8 hover:shadow-xl transition-all hover:scale-105 border-2 border-dashed border-purple-300 group"
            >
              <div className="flex flex-col items-center">
                <div className="w-32 h-32 rounded-full bg-purple-50 flex items-center justify-center mb-4 group-hover:bg-purple-100 transition">
                  <Plus className="w-16 h-16 text-purple-400 group-hover:text-purple-600 transition" />
                </div>
                <h3 className="text-2xl font-bold text-gray-700 mb-1">Add Child</h3>
                <p className="text-gray-500">Create a new profile</p>
              </div>
            </button>
          </motion.div>
        </div>
        
        {children.length === 0 && (
          <div className="text-center mt-12 bg-white rounded-2xl shadow-lg p-12">
            <h3 className="text-2xl font-semibold text-gray-800 mb-4">
              Let's create your first child profile!
            </h3>
            <p className="text-gray-600 mb-6">
              Start by adding a child profile to begin their learning journey.
            </p>
            <button
              onClick={() => navigate('/dashboard?tab=children')}
              className="px-8 py-4 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg font-semibold hover:from-purple-700 hover:to-blue-700 transition"
            >
              Create First Profile
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default ChildSelect;


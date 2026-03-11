import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppStore } from '../store/useAppStore';
import { ArrowLeft, Shapes, Music, Brain } from 'lucide-react';
import { motion } from 'framer-motion';
import ReminderNotification from '../components/ReminderNotification';

const games = [
  {
    id: 'shape-match',
    name: 'Shape & Color Matching',
    icon: Shapes,
    description: 'Match shapes and colors together',
    color: 'from-pink-400 to-rose-500',
    route: '/games/shape-match',
  },
  {
    id: 'sound-match',
    name: 'Animal Sound Game',
    icon: Music,
    description: 'Listen and match animal sounds',
    color: 'from-blue-400 to-cyan-500',
    route: '/games/sound-match',
  },
  {
    id: 'memory-puzzle',
    name: 'Memory Puzzle',
    icon: Brain,
    description: 'Find matching pairs',
    color: 'from-purple-400 to-violet-500',
    route: '/games/memory-puzzle',
  },
];

const GameLauncher = () => {
  const navigate = useNavigate();
  const { currentChild } = useAppStore();
  
  useEffect(() => {
    if (!currentChild) {
      navigate('/children');
    }
  }, [currentChild, navigate]);
  
  if (!currentChild) {
    return null;
  }
  
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-blue-100 to-pink-100 p-6">
      {/* Reminder Notification */}
      {currentChild && <ReminderNotification childId={currentChild._id} />}
      {/* Header */}
      <div className="max-w-6xl mx-auto mb-8">
        <button
          onClick={() => navigate('/children')}
          className="mb-6 px-4 py-2 bg-white rounded-lg shadow hover:shadow-md transition flex items-center gap-2 text-gray-700"
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Children
        </button>
        
        <div className="bg-white rounded-2xl shadow-lg p-8 mb-8">
          <div className="flex items-center gap-6">
            {currentChild.avatar ? (
              <img
                src={currentChild.avatar}
                alt={currentChild.name}
                className="w-24 h-24 rounded-full object-cover border-4 border-purple-200"
              />
            ) : (
              <div className="w-24 h-24 rounded-full bg-gradient-to-br from-purple-400 to-blue-400 flex items-center justify-center border-4 border-purple-200">
                <span className="text-3xl">👦</span>
              </div>
            )}
            <div>
              <h1 className="text-3xl font-bold text-gray-800 mb-2">
                Hi {currentChild.name}! 👋
              </h1>
              <p className="text-gray-600 text-lg">
                Choose a fun game to play today!
              </p>
            </div>
          </div>
        </div>
      </div>
      
      {/* Game Grid */}
      <div className="max-w-6xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {games.map((game, index) => {
            const Icon = game.icon;
            return (
              <motion.div
                key={game.id}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: index * 0.1 }}
              >
                <button
                  onClick={() => navigate(game.route)}
                  className="w-full bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-2xl transition-all hover:scale-105 group"
                >
                  <div className={`h-48 bg-gradient-to-br ${game.color} flex items-center justify-center group-hover:scale-110 transition-transform`}>
                    <Icon className="w-24 h-24 text-white" />
                  </div>
                  <div className="p-6">
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">
                      {game.name}
                    </h3>
                    <p className="text-gray-600 mb-4">
                      {game.description}
                    </p>
                    <div className="flex items-center justify-between">
                      <span className="text-purple-600 font-semibold">
                        Play Now →
                      </span>
                      <div className="flex gap-1">
                        <div className="w-2 h-2 rounded-full bg-green-400"></div>
                        <div className="w-2 h-2 rounded-full bg-yellow-400"></div>
                        <div className="w-2 h-2 rounded-full bg-red-400"></div>
                      </div>
                    </div>
                  </div>
                </button>
              </motion.div>
            );
          })}
        </div>
        
        {/* Encouragement Box */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="mt-12 bg-gradient-to-r from-yellow-100 to-orange-100 rounded-2xl shadow-lg p-8"
        >
          <div className="flex items-center gap-4">
            <span className="text-6xl">🌟</span>
            <div>
              <h3 className="text-2xl font-bold text-gray-800 mb-2">
                You're doing great, {currentChild.name}!
              </h3>
              <p className="text-gray-700">
                Every game helps you learn something new. Have fun!
              </p>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default GameLauncher;


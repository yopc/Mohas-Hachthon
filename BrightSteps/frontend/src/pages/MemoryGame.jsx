import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppStore } from '../store/useAppStore';
import { ArrowLeft, Trophy } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { playSuccessSound, playErrorSound, playCelebrationSound, playClickSound, speak } from '../utils/soundUtils';
import ReminderNotification from '../components/ReminderNotification';

const emojis = ['🌟', '🎨', '🚀', '🎭', '🎪', '🎯', '🎨', '🌈', '⭐', '🎁', '🎵', '🎸'];

const levels = {
  easy: { grid: [2, 2], pairs: 2 },    // 2x2 = 4 cards = 2 pairs
  medium: { grid: [4, 2], pairs: 4 },  // 4x2 = 8 cards = 4 pairs
  hard: { grid: [4, 3], pairs: 6 },    // 4x3 = 12 cards = 6 pairs
};

const MemoryGame = () => {
  const navigate = useNavigate();
  const { currentChild, saveGameRecord } = useAppStore();
  
  const [level, setLevel] = useState('easy');
  const [gameStarted, setGameStarted] = useState(false);
  const [startTime, setStartTime] = useState(null);
  const [cards, setCards] = useState([]);
  const [flipped, setFlipped] = useState([]);
  const [matched, setMatched] = useState([]);
  const [moves, setMoves] = useState(0);
  const [mistakes, setMistakes] = useState(0);
  const [gameComplete, setGameComplete] = useState(false);
  const [canFlip, setCanFlip] = useState(true);
  
  useEffect(() => {
    if (!currentChild) {
      navigate('/children');
    }
  }, [currentChild, navigate]);
  
  const startGame = () => {
    const { pairs } = levels[level];
    const selectedEmojis = emojis.slice(0, pairs);
    const gameEmojis = [...selectedEmojis, ...selectedEmojis];
    const shuffled = gameEmojis.sort(() => Math.random() - 0.5);
    
    const newCards = shuffled.map((emoji, index) => ({
      id: index,
      emoji,
      isFlipped: false,
      isMatched: false,
    }));
    
    setCards(newCards);
    setFlipped([]);
    setMatched([]);
    setMoves(0);
    setMistakes(0);
    setGameStarted(true);
    setStartTime(new Date());
    setGameComplete(false);
    setCanFlip(true);
    
    speak('Match the pairs!');
  };
  
  const handleCardClick = async (index) => {
    if (!canFlip) return;
    if (flipped.includes(index)) return;
    if (matched.includes(index)) return;
    if (flipped.length >= 2) return;
    
    await playClickSound();
    
    const newFlipped = [...flipped, index];
    setFlipped(newFlipped);
    
    if (newFlipped.length === 2) {
      setMoves(moves + 1);
      setCanFlip(false);
      
      const [first, second] = newFlipped;
      
      if (cards[first].emoji === cards[second].emoji) {
        // Match!
        await playSuccessSound();
        const newMatched = [...matched, first, second];
        setMatched(newMatched);
        setFlipped([]);
        setCanFlip(true);
        speak('Great match!');
        
        // Check if game is complete
        if (newMatched.length === cards.length) {
          finishGame();
        }
      } else {
        // No match
        await playErrorSound();
        setMistakes(mistakes + 1);
        speak('Try again!');
        
        setTimeout(() => {
          setFlipped([]);
          setCanFlip(true);
        }, 1500);
      }
    }
  };
  
  const saveCurrentProgress = async (isComplete = false) => {
    if (!startTime || moves === 0) {
      console.log('No progress to save yet');
      return;
    }
    
    const endTime = new Date();
    const correctPairs = matched.length / 2;
    
    try {
      console.log('Saving game record for child:', currentChild._id);
      const result = await saveGameRecord({
        childId: currentChild._id,
        gameName: 'memory-puzzle',
        level,
        startTime: startTime.toISOString(),
        endTime: endTime.toISOString(),
        correctCount: correctPairs,
        attemptCount: moves,
        mistakes,
        additionalData: {
          totalPairs: cards.length / 2,
          completed: isComplete,
        },
      });
      console.log('✅ Game record saved successfully:', result);
      return result;
    } catch (error) {
      console.error('❌ Failed to save game record:', error);
      console.error('Error response:', error.response);
      console.error('Error status:', error.response?.status);
      console.error('Error data:', error.response?.data);
      console.error('Error message:', error.message);
      console.error('Request URL:', error.config?.url);
      console.error('Request data:', error.config?.data);
    }
  };
  
  const finishGame = async () => {
    const endTime = new Date();
    await playCelebrationSound();
    setGameComplete(true);
    speak('Perfect! You found all the pairs!');
    
    // Save completed game record
    await saveCurrentProgress(true);
  };
  
  const handlePlayAgain = async () => {
    // Save current progress before restarting
    await saveCurrentProgress(false);
    startGame();
  };
  
  const handleBackToGames = async () => {
    // Save current progress before leaving
    await saveCurrentProgress(false);
    navigate('/games');
  };
  
  const changeDifficulty = (newLevel) => {
    setLevel(newLevel);
  };
  
  if (!currentChild) {
    return null;
  }
  
  const { grid } = levels[level];
  
  return (
    <div className="min-h-screen bg-gradient-to-br from-violet-100 via-purple-100 to-fuchsia-100 p-6">
      {/* Reminder Notification */}
      {currentChild && <ReminderNotification childId={currentChild._id} />}
      {/* Header */}
      <div className="max-w-6xl mx-auto mb-8">
        <button
          onClick={handleBackToGames}
          className="mb-6 px-4 py-2 bg-white rounded-lg shadow hover:shadow-md transition flex items-center gap-2"
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Games
        </button>
        
        {/* Game Info */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-3xl font-bold text-gray-800 mb-2">
                🧠 Memory Puzzle
              </h1>
              <p className="text-gray-600">
                Find all the matching pairs!
              </p>
            </div>
            
            {gameStarted && !gameComplete && (
              <div className="flex gap-4">
                <div className="text-center">
                  <p className="text-sm text-gray-600">Moves</p>
                  <p className="text-2xl font-bold text-purple-600">{moves}</p>
                </div>
                <div className="text-center">
                  <p className="text-sm text-gray-600">Pairs Found</p>
                  <p className="text-2xl font-bold text-green-600">{matched.length / 2}/{cards.length / 2}</p>
                </div>
                <div className="text-center">
                  <p className="text-sm text-gray-600">Mistakes</p>
                  <p className="text-2xl font-bold text-red-600">{mistakes}</p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
      
      {/* Game Content */}
      <div className="max-w-4xl mx-auto">
        {!gameStarted ? (
          /* Start Screen */
          <div className="bg-white rounded-2xl shadow-lg p-12 text-center">
            <h2 className="text-4xl font-bold text-gray-800 mb-6">
              Choose Your Level
            </h2>
            
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
              {Object.entries(levels).map(([lvl, config]) => (
                <button
                  key={lvl}
                  onClick={() => changeDifficulty(lvl)}
                  className={`p-8 rounded-xl border-4 transition-all ${
                    level === lvl
                      ? 'border-purple-500 bg-purple-50'
                      : 'border-gray-200 hover:border-purple-300'
                  }`}
                >
                  <div className="text-4xl mb-4">
                    {lvl === 'easy' ? '😊' : lvl === 'medium' ? '🙂' : '😎'}
                  </div>
                  <h3 className="text-2xl font-bold text-gray-800 mb-2 capitalize">
                    {lvl}
                  </h3>
                  <p className="text-gray-600">
                    {config.grid[0]}×{config.grid[1]} grid
                  </p>
                  <p className="text-sm text-gray-500">
                    ({config.pairs} pairs)
                  </p>
                </button>
              ))}
            </div>
            
            <button
              onClick={startGame}
              className="px-12 py-6 bg-gradient-to-r from-purple-600 to-violet-600 text-white text-2xl font-bold rounded-2xl hover:from-purple-700 hover:to-violet-700 transition shadow-lg"
            >
              Start Playing! 🎮
            </button>
          </div>
        ) : gameComplete ? (
          /* Game Complete Screen */
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-2xl shadow-lg p-12 text-center"
          >
            <div className="text-8xl mb-6">🎉</div>
            <h2 className="text-4xl font-bold text-gray-800 mb-4">
              Excellent Work, {currentChild.name}!
            </h2>
            <p className="text-xl text-gray-600 mb-8">
              You found all {cards.length / 2} pairs!
            </p>
            
            <div className="grid grid-cols-3 gap-6 mb-8 max-w-2xl mx-auto">
              <div className="bg-purple-50 p-6 rounded-xl">
                <Trophy className="w-12 h-12 text-purple-600 mx-auto mb-2" />
                <p className="text-sm text-gray-600">Total Moves</p>
                <p className="text-3xl font-bold text-purple-600">{moves}</p>
              </div>
              <div className="bg-green-50 p-6 rounded-xl">
                <div className="text-4xl mb-2">✅</div>
                <p className="text-sm text-gray-600">Pairs Found</p>
                <p className="text-3xl font-bold text-green-600">{matched.length / 2}</p>
              </div>
              <div className="bg-blue-50 p-6 rounded-xl">
                <div className="text-4xl mb-2">🎯</div>
                <p className="text-sm text-gray-600">Accuracy</p>
                <p className="text-3xl font-bold text-blue-600">
                  {Math.round(((matched.length / 2) / moves) * 100)}%
                </p>
              </div>
            </div>
            
            <div className="flex gap-4 justify-center">
              <button
                onClick={handlePlayAgain}
                className="px-8 py-4 bg-gradient-to-r from-purple-600 to-violet-600 text-white text-xl font-bold rounded-xl hover:from-purple-700 hover:to-violet-700 transition"
              >
                Play Again 🔄
              </button>
              <button
                onClick={handleBackToGames}
                className="px-8 py-4 bg-gray-200 text-gray-800 text-xl font-bold rounded-xl hover:bg-gray-300 transition"
              >
                Back to Games
              </button>
            </div>
          </motion.div>
        ) : (
          /* Active Game */
          <div>
            <div
              className="grid gap-4 mx-auto"
              style={{
                gridTemplateColumns: `repeat(${grid[0]}, minmax(0, 1fr))`,
                maxWidth: `${grid[0] * 150}px`,
              }}
            >
              <AnimatePresence>
                {cards.map((card, index) => {
                  const isFlipped = flipped.includes(index) || matched.includes(index);
                  
                  return (
                    <motion.button
                      key={card.id}
                      initial={{ opacity: 0, scale: 0 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ delay: index * 0.05 }}
                      whileHover={{ scale: isFlipped ? 1 : 1.05 }}
                      whileTap={{ scale: isFlipped ? 1 : 0.95 }}
                      onClick={() => handleCardClick(index)}
                      className={`aspect-square rounded-2xl shadow-lg transition-all ${
                        isFlipped ? 'bg-gradient-to-br from-purple-400 to-violet-400' : 'bg-white hover:shadow-xl'
                      } ${matched.includes(index) ? 'opacity-50' : ''}`}
                      disabled={isFlipped && !matched.includes(index)}
                    >
                      <motion.div
                        initial={false}
                        animate={{ rotateY: isFlipped ? 180 : 0 }}
                        transition={{ duration: 0.3 }}
                        className="w-full h-full flex items-center justify-center"
                        style={{ transformStyle: 'preserve-3d' }}
                      >
                        {isFlipped ? (
                          <span className="text-6xl" style={{ transform: 'rotateY(180deg)' }}>
                            {card.emoji}
                          </span>
                        ) : (
                          <span className="text-5xl">❓</span>
                        )}
                      </motion.div>
                    </motion.button>
                  );
                })}
              </AnimatePresence>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default MemoryGame;


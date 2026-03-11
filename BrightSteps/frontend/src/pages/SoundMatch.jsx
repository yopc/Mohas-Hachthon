import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppStore } from '../store/useAppStore';
import { ArrowLeft, Volume2, Trophy } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { playSuccessSound, playErrorSound, playCelebrationSound, animalSounds, speak } from '../utils/soundUtils';
import ReminderNotification from '../components/ReminderNotification';

const animals = [
  { name: 'dog', emoji: '🐕', sound: 'dog' },
  { name: 'cat', emoji: '🐈', sound: 'cat' },
  { name: 'lion', emoji: '🦁', sound: 'lion' },
  { name: 'cow', emoji: '🐄', sound: 'cow' },
  { name: 'sheep', emoji: '🐑', sound: 'sheep' },
  { name: 'bird', emoji: '🐦', sound: 'bird' },
];

const levels = {
  easy: 2,
  medium: 4,
  hard: 6,
};

const SoundMatch = () => {
  const navigate = useNavigate();
  const { currentChild, saveGameRecord } = useAppStore();
  
  const [level, setLevel] = useState('easy');
  const [gameStarted, setGameStarted] = useState(false);
  const [startTime, setStartTime] = useState(null);
  const [targetAnimal, setTargetAnimal] = useState(null);
  const [options, setOptions] = useState([]);
  const [score, setScore] = useState(0);
  const [attempts, setAttempts] = useState(0);
  const [correct, setCorrect] = useState(0);
  const [mistakes, setMistakes] = useState(0);
  const [gameComplete, setGameComplete] = useState(false);
  const [round, setRound] = useState(1);
  const [maxRounds] = useState(5);
  const [soundPlayed, setSoundPlayed] = useState(false);
  
  useEffect(() => {
    if (!currentChild) {
      navigate('/children');
    }
  }, [currentChild, navigate]);
  
  const startGame = () => {
    setGameStarted(true);
    setStartTime(new Date());
    setScore(0);
    setAttempts(0);
    setCorrect(0);
    setMistakes(0);
    setRound(1);
    setGameComplete(false);
    generateRound();
    speak('Listen to the sound and find the animal!');
  };
  
  const generateRound = () => {
    const numAnimals = levels[level];
    const shuffled = [...animals].sort(() => Math.random() - 0.5);
    const selected = shuffled.slice(0, numAnimals);
    
    const target = selected[Math.floor(Math.random() * selected.length)];
    setTargetAnimal(target);
    setOptions(selected.sort(() => Math.random() - 0.5));
    setSoundPlayed(false);
    
    // Auto-play sound after a delay
    setTimeout(() => {
      playAnimalSound(target);
    }, 1000);
  };
  
  const playAnimalSound = async (animal) => {
    if (animalSounds[animal.sound]) {
      await animalSounds[animal.sound]();
      setSoundPlayed(true);
    }
  };
  
  const handleAnimalClick = async (animal) => {
    setAttempts(attempts + 1);
    
    if (animal.name === targetAnimal.name) {
      // Correct!
      setCorrect(correct + 1);
      setScore(score + 10);
      await playSuccessSound();
      speak(`Yes! It's a ${animal.name}!`);
      
      // Move to next round
      if (round < maxRounds) {
        setTimeout(() => {
          setRound(round + 1);
          generateRound();
        }, 2000);
      } else {
        // Game complete
        finishGame();
      }
    } else {
      // Wrong
      setMistakes(mistakes + 1);
      await playErrorSound();
      speak('Try again! Listen carefully.');
    }
  };
  
  const saveCurrentProgress = async (isComplete = false) => {
    if (!startTime || attempts === 0) {
      console.log('No progress to save yet');
      return;
    }
    
    const endTime = new Date();
    const finalCorrect = isComplete ? correct + 1 : correct;
    const finalAttempts = isComplete ? attempts + 1 : attempts;
    
    try {
      console.log('Saving game record for child:', currentChild._id);
      const result = await saveGameRecord({
        childId: currentChild._id,
        gameName: 'sound-match',
        level,
        startTime: startTime.toISOString(),
        endTime: endTime.toISOString(),
        correctCount: finalCorrect,
        attemptCount: finalAttempts,
        mistakes,
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
    speak('Wonderful! You matched all the sounds!');
    
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
    if (gameStarted) {
      startGame();
    }
  };
  
  if (!currentChild) {
    return null;
  }
  
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-100 via-cyan-100 to-teal-100 p-6">
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
                🔊 Animal Sound Game
              </h1>
              <p className="text-gray-600">
                Listen to the sound and click the correct animal!
              </p>
            </div>
            
            {gameStarted && !gameComplete && (
              <div className="flex gap-4">
                <div className="text-center">
                  <p className="text-sm text-gray-600">Round</p>
                  <p className="text-2xl font-bold text-blue-600">{round}/{maxRounds}</p>
                </div>
                <div className="text-center">
                  <p className="text-sm text-gray-600">Score</p>
                  <p className="text-2xl font-bold text-green-600">{score}</p>
                </div>
                <div className="text-center">
                  <p className="text-sm text-gray-600">Correct</p>
                  <p className="text-2xl font-bold text-purple-600">{correct}/{attempts}</p>
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
              {Object.keys(levels).map((lvl) => (
                <button
                  key={lvl}
                  onClick={() => changeDifficulty(lvl)}
                  className={`p-8 rounded-xl border-4 transition-all ${
                    level === lvl
                      ? 'border-blue-500 bg-blue-50'
                      : 'border-gray-200 hover:border-blue-300'
                  }`}
                >
                  <div className="text-4xl mb-4">
                    {lvl === 'easy' ? '😊' : lvl === 'medium' ? '🙂' : '😎'}
                  </div>
                  <h3 className="text-2xl font-bold text-gray-800 mb-2 capitalize">
                    {lvl}
                  </h3>
                  <p className="text-gray-600">
                    {levels[lvl]} animals
                  </p>
                </button>
              ))}
            </div>
            
            <button
              onClick={startGame}
              className="px-12 py-6 bg-gradient-to-r from-blue-600 to-cyan-600 text-white text-2xl font-bold rounded-2xl hover:from-blue-700 hover:to-cyan-700 transition shadow-lg"
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
              Fantastic, {currentChild.name}!
            </h2>
            <p className="text-xl text-gray-600 mb-8">
              You matched all the animal sounds!
            </p>
            
            <div className="grid grid-cols-3 gap-6 mb-8 max-w-2xl mx-auto">
              <div className="bg-blue-50 p-6 rounded-xl">
                <Trophy className="w-12 h-12 text-blue-600 mx-auto mb-2" />
                <p className="text-sm text-gray-600">Final Score</p>
                <p className="text-3xl font-bold text-blue-600">{score}</p>
              </div>
              <div className="bg-green-50 p-6 rounded-xl">
                <div className="text-4xl mb-2">✅</div>
                <p className="text-sm text-gray-600">Correct</p>
                <p className="text-3xl font-bold text-green-600">{correct}</p>
              </div>
              <div className="bg-purple-50 p-6 rounded-xl">
                <div className="text-4xl mb-2">🎯</div>
                <p className="text-sm text-gray-600">Accuracy</p>
                <p className="text-3xl font-bold text-purple-600">
                  {Math.round((correct / attempts) * 100)}%
                </p>
              </div>
            </div>
            
            <div className="flex gap-4 justify-center">
              <button
                onClick={handlePlayAgain}
                className="px-8 py-4 bg-gradient-to-r from-blue-600 to-cyan-600 text-white text-xl font-bold rounded-xl hover:from-blue-700 hover:to-cyan-700 transition"
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
          <div className="space-y-8">
            {/* Sound Player */}
            <motion.div
              key={`sound-${round}`}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="bg-white rounded-2xl shadow-lg p-12 text-center"
            >
              <h3 className="text-2xl font-bold text-gray-800 mb-6">
                🎧 Listen to the sound:
              </h3>
              
              <button
                onClick={() => targetAnimal && playAnimalSound(targetAnimal)}
                className="mx-auto w-48 h-48 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-full shadow-2xl hover:shadow-3xl transition-all hover:scale-105 flex items-center justify-center group"
              >
                <Volume2 className="w-24 h-24 text-white group-hover:animate-pulse" />
              </button>
              
              <p className="text-lg text-gray-600 mt-6">
                {soundPlayed ? 'Click to play again' : 'Playing sound...'}
              </p>
            </motion.div>
            
            {/* Animal Options */}
            <div>
              <h3 className="text-2xl font-bold text-gray-800 mb-4 text-center">
                Which animal makes this sound?
              </h3>
              
              <div className={`grid grid-cols-${Math.min(options.length, 3)} gap-6`}>
                <AnimatePresence>
                  {options.map((animal, index) => (
                    <motion.button
                      key={`${animal.name}-${index}-${round}`}
                      initial={{ opacity: 0, scale: 0.8 }}
                      animate={{ opacity: 1, scale: 1 }}
                      exit={{ opacity: 0, scale: 0.8 }}
                      transition={{ delay: index * 0.1 }}
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handleAnimalClick(animal)}
                      className="bg-white rounded-2xl shadow-lg p-8 hover:shadow-2xl transition-all"
                    >
                      <div className="text-8xl mb-4">
                        {animal.emoji}
                      </div>
                      <p className="text-xl font-semibold text-gray-800 capitalize">
                        {animal.name}
                      </p>
                    </motion.button>
                  ))}
                </AnimatePresence>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default SoundMatch;


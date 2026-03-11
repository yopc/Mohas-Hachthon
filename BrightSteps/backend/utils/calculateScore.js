/**
 * Calculate game score based on performance metrics
 * @param {number} correctCount - Number of correct answers
 * @param {number} attemptCount - Total number of attempts
 * @param {number} mistakes - Number of mistakes made
 * @param {string} level - Difficulty level (easy, medium, hard)
 * @returns {number} Calculated score
 */
export const calculateScore = (correctCount, attemptCount, mistakes, level) => {
  const levelBonus = {
    easy: 10,
    medium: 20,
    hard: 30,
  };
  
  const accuracy = attemptCount > 0 
    ? (correctCount / attemptCount) * 100 
    : 0;
  
  const score = Math.max(0, 
    accuracy + 
    (levelBonus[level] || 0) - 
    (mistakes * 2)
  );
  
  return Math.round(score);
};

/**
 * Calculate time bonus based on completion time
 * @param {number} durationMs - Time taken in milliseconds
 * @param {string} gameName - Name of the game
 * @returns {number} Time bonus points
 */
export const calculateTimeBonus = (durationMs, gameName) => {
  const targetTimes = {
    'shape-match': 30000, // 30 seconds
    'sound-match': 20000, // 20 seconds
    'memory-puzzle': 60000, // 60 seconds
  };
  
  const targetTime = targetTimes[gameName] || 30000;
  
  if (durationMs < targetTime) {
    return Math.round((targetTime - durationMs) / 1000);
  }
  
  return 0;
};

/**
 * Determine performance level based on score
 * @param {number} score - Game score
 * @returns {string} Performance level
 */
export const getPerformanceLevel = (score) => {
  if (score >= 90) return 'excellent';
  if (score >= 75) return 'good';
  if (score >= 50) return 'fair';
  return 'needs-practice';
};


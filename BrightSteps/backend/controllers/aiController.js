import { generateAIResponse, generateJSON } from '../config/openai.js';
import GameRecord from '../models/GameRecord.js';
import Child from '../models/Child.js';

/**
 * Generate adaptive difficulty recommendation
 * POST /api/ai/adapt
 */
export const getAdaptiveRecommendation = async (req, res) => {
  try {
    const { childId } = req.body;
    
    // Verify child belongs to parent
    const child = await Child.findOne({
      _id: childId,
      parentId: req.parent._id,
    });
    
    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found',
      });
    }
    
    // Get last 7 game sessions
    const recentSessions = await GameRecord.find({ childId })
      .sort({ createdAt: -1 })
      .limit(7);
    
    if (recentSessions.length === 0) {
      return res.status(200).json({
        success: true,
        data: {
          recommendation: 'easy',
          reason: 'No previous sessions found. Starting with easy difficulty.',
          motivation: 'Let\'s start your learning journey! Have fun! 🌟',
        },
      });
    }
    
    // Calculate average performance
    const avgScore = recentSessions.reduce((sum, s) => sum + s.score, 0) / recentSessions.length;
    const avgAccuracy = recentSessions.reduce((sum, s) => 
      sum + (s.correctCount / s.attemptCount) * 100, 0
    ) / recentSessions.length;
    
    // Build prompt for AI
    const prompt = `
Analyze this child's game performance and recommend the next difficulty level.

Recent sessions (last 7):
${recentSessions.map(s => `
- Game: ${s.gameName}, Level: ${s.level}, Score: ${s.score}, Accuracy: ${(s.correctCount / s.attemptCount * 100).toFixed(1)}%
`).join('')}

Average Score: ${avgScore.toFixed(1)}
Average Accuracy: ${avgAccuracy.toFixed(1)}%
Current Preferred Difficulty: ${child.preferredDifficulty}

Respond with JSON containing:
{
  "recommendation": "easy" | "medium" | "hard",
  "reason": "brief explanation of why",
  "motivation": "short encouraging message for the child (1 sentence)",
  "tips": "helpful tip for parents (1 sentence)"
}
`;
    
    const result = await generateJSON(prompt, {
      systemPrompt: 'You are an expert in autism education and adaptive learning. Provide thoughtful, encouraging recommendations.',
    });
    
    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error('AI recommendation error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to generate recommendation',
      error: error.message,
    });
  }
};

/**
 * Generate kid's song lyrics
 * POST /api/ai/song
 */
export const generateSongLyrics = async (req, res) => {
  try {
    const { type, childName } = req.body; // type: breakfast, lunch, dinner, etc.
    
    const prompt = `
Create short, simple, and fun song lyrics (4-6 lines) about ${type} time for a child named ${childName}.
The song should be:
- Cheerful and encouraging
- Simple words for young children
- Easy to sing
- Autism-friendly (clear, positive, structured)

Just provide the lyrics, no title or extra formatting.
`;
    
    const lyrics = await generateAIResponse(prompt, {
      systemPrompt: 'You are a children\'s song writer who creates simple, joyful songs for young children.',
      temperature: 0.8,
      maxTokens: 150,
    });
    
    res.status(200).json({
      success: true,
      data: {
        lyrics: lyrics.trim(),
        type,
      },
    });
  } catch (error) {
    console.error('Song generation error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to generate song lyrics',
      error: error.message,
    });
  }
};

/**
 * Generate motivational message for child
 * POST /api/ai/motivate
 */
export const generateMotivation = async (req, res) => {
  try {
    const { childId, context } = req.body;
    
    // Verify child belongs to parent
    const child = await Child.findOne({
      _id: childId,
      parentId: req.parent._id,
    });
    
    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found',
      });
    }
    
    const prompt = `
Generate a short, encouraging message (1-2 sentences) for ${child.name}, age ${child.age}.
Context: ${context || 'general encouragement'}

The message should be:
- Simple and clear
- Positive and uplifting
- Age-appropriate
- Autism-friendly (direct, concrete)
`;
    
    const message = await generateAIResponse(prompt, {
      systemPrompt: 'You are a supportive educator who creates encouraging messages for children with autism.',
      temperature: 0.7,
      maxTokens: 100,
    });
    
    res.status(200).json({
      success: true,
      data: {
        message: message.trim(),
      },
    });
  } catch (error) {
    console.error('Motivation generation error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to generate motivation',
      error: error.message,
    });
  }
};

/**
 * Generate parent guidance suggestion
 * POST /api/ai/parent-tip
 */
export const generateParentTip = async (req, res) => {
  try {
    const { childId, period = 'week' } = req.body;
    
    // Verify child belongs to parent
    const child = await Child.findOne({
      _id: childId,
      parentId: req.parent._id,
    });
    
    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found',
      });
    }
    
    // Get recent performance data
    const days = period === 'day' ? 1 : period === 'week' ? 7 : 30;
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);
    
    const records = await GameRecord.find({
      childId,
      createdAt: { $gte: startDate },
    });
    
    if (records.length === 0) {
      return res.status(200).json({
        success: true,
        data: {
          tip: 'Start with short, regular practice sessions. Consistency helps build confidence and skills.',
        },
      });
    }
    
    // Analyze performance
    const gameStats = {};
    records.forEach(r => {
      if (!gameStats[r.gameName]) {
        gameStats[r.gameName] = { sessions: 0, avgScore: 0, totalScore: 0 };
      }
      gameStats[r.gameName].sessions++;
      gameStats[r.gameName].totalScore += r.score;
    });
    
    Object.keys(gameStats).forEach(game => {
      gameStats[game].avgScore = gameStats[game].totalScore / gameStats[game].sessions;
    });
    
    const prompt = `
Based on this child's recent performance, provide ONE specific, actionable tip for parents.

Child: ${child.name}, Age: ${child.age}
Period: Last ${days} days
Total sessions: ${records.length}

Game performance:
${Object.entries(gameStats).map(([game, stats]) => 
  `- ${game}: ${stats.sessions} sessions, avg score ${stats.avgScore.toFixed(1)}`
).join('\n')}

Provide a brief, practical tip (2-3 sentences) that helps parents support their child's learning.
`;
    
    const tip = await generateAIResponse(prompt, {
      systemPrompt: 'You are an expert in autism education and parent guidance. Provide practical, supportive advice.',
      temperature: 0.7,
      maxTokens: 150,
    });
    
    res.status(200).json({
      success: true,
      data: {
        tip: tip.trim(),
      },
    });
  } catch (error) {
    console.error('Parent tip generation error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to generate parent tip',
      error: error.message,
    });
  }
};


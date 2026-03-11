import GameRecord from '../models/GameRecord.js';
import Child from '../models/Child.js';

/**
 * Save a new game record
 * POST /api/games/record
 */
export const saveGameRecord = async (req, res) => {
  try {
    const {
      childId,
      gameName,
      level,
      startTime,
      endTime,
      correctCount,
      attemptCount,
      mistakes,
      additionalData,
    } = req.body;
    
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
    
    // Calculate duration
    const start = new Date(startTime);
    const end = new Date(endTime);
    const durationMs = end - start;
    
    // Create game record (score will be calculated by pre-save hook)
    const gameRecord = await GameRecord.create({
      childId,
      gameName,
      level,
      startTime: start,
      endTime: end,
      durationMs,
      correctCount,
      attemptCount,
      mistakes: mistakes || 0,
      additionalData: additionalData || {},
    });
    
    res.status(201).json({
      success: true,
      data: gameRecord,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get game records for a child
 * GET /api/games/records/:childId
 */
export const getGameRecords = async (req, res) => {
  try {
    const { childId } = req.params;
    const { gameName, limit = 50, startDate, endDate } = req.query;
    
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
    
    // Build query
    const query = { childId };
    
    if (gameName) {
      query.gameName = gameName;
    }
    
    if (startDate || endDate) {
      query.createdAt = {};
      if (startDate) query.createdAt.$gte = new Date(startDate);
      if (endDate) query.createdAt.$lte = new Date(endDate);
    }
    
    const records = await GameRecord.find(query)
      .sort({ createdAt: -1 })
      .limit(parseInt(limit));
    
    res.status(200).json({
      success: true,
      count: records.length,
      data: records,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get progress statistics for a child
 * GET /api/games/progress/:childId
 */
export const getProgress = async (req, res) => {
  try {
    const { childId } = req.params;
    const { period = 'week' } = req.query; // day, week, month, all
    
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
    
    // Calculate date range
    const now = new Date();
    let startDate = new Date(0); // Beginning of time
    
    switch (period) {
      case 'day':
        startDate = new Date(now.setHours(0, 0, 0, 0));
        break;
      case 'week':
        startDate = new Date(now.setDate(now.getDate() - 7));
        break;
      case 'month':
        startDate = new Date(now.setMonth(now.getMonth() - 1));
        break;
    }
    
    // Get all records in period
    const records = await GameRecord.find({
      childId,
      createdAt: { $gte: startDate },
    });
    
    // Calculate statistics
    const stats = {
      totalSessions: records.length,
      totalCorrect: 0,
      totalAttempts: 0,
      totalMistakes: 0,
      totalDurationMs: 0,
      averageScore: 0,
      gameBreakdown: {},
      dailyStats: [],
      levelBreakdown: {},
    };
    
    records.forEach(record => {
      stats.totalCorrect += record.correctCount;
      stats.totalAttempts += record.attemptCount;
      stats.totalMistakes += record.mistakes;
      stats.totalDurationMs += record.durationMs;
      
      // Game breakdown
      if (!stats.gameBreakdown[record.gameName]) {
        stats.gameBreakdown[record.gameName] = {
          sessions: 0,
          avgScore: 0,
          totalScore: 0,
          bestScore: 0,
        };
      }
      stats.gameBreakdown[record.gameName].sessions++;
      stats.gameBreakdown[record.gameName].totalScore += record.score;
      stats.gameBreakdown[record.gameName].bestScore = Math.max(
        stats.gameBreakdown[record.gameName].bestScore,
        record.score
      );
      
      // Level breakdown
      if (!stats.levelBreakdown[record.level]) {
        stats.levelBreakdown[record.level] = 0;
      }
      stats.levelBreakdown[record.level]++;
    });
    
    // Calculate averages
    if (records.length > 0) {
      stats.averageScore = records.reduce((sum, r) => sum + r.score, 0) / records.length;
      stats.accuracyPercent = (stats.totalCorrect / stats.totalAttempts) * 100;
      stats.avgDurationSeconds = Math.round(stats.totalDurationMs / records.length / 1000);
      
      // Calculate game averages
      Object.keys(stats.gameBreakdown).forEach(game => {
        stats.gameBreakdown[game].avgScore = 
          stats.gameBreakdown[game].totalScore / stats.gameBreakdown[game].sessions;
      });
    }
    
    // Get top performing game
    let topGame = null;
    let highestAvg = 0;
    Object.entries(stats.gameBreakdown).forEach(([game, data]) => {
      if (data.avgScore > highestAvg) {
        highestAvg = data.avgScore;
        topGame = game;
      }
    });
    stats.topGame = topGame;
    
    res.status(200).json({
      success: true,
      data: stats,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get daily stats for charts
 * GET /api/games/daily-stats/:childId
 */
export const getDailyStats = async (req, res) => {
  try {
    const { childId } = req.params;
    const { days = 7 } = req.query;
    
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
    
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - parseInt(days));
    
    const records = await GameRecord.aggregate([
      {
        $match: {
          childId: child._id,
          createdAt: { $gte: startDate },
        },
      },
      {
        $group: {
          _id: {
            date: { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } },
            gameName: '$gameName',
          },
          sessions: { $sum: 1 },
          avgScore: { $avg: '$score' },
          totalCorrect: { $sum: '$correctCount' },
          totalAttempts: { $sum: '$attemptCount' },
        },
      },
      {
        $sort: { '_id.date': 1 },
      },
    ]);
    
    res.status(200).json({
      success: true,
      data: records,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};


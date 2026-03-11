import { sendEmail } from '../config/mailer.js';
import generateEmailTemplate from '../utils/emailTemplate.js';
import Child from '../models/Child.js';
import Parent from '../models/Parent.js';
import GameRecord from '../models/GameRecord.js';
import { generateAIResponse } from '../config/gemini.js';

/**
 * Send progress report email
 * @param {String} childId - Child ID
 * @param {Object} parent - Parent object (optional, will fetch if not provided)
 */
export const sendProgressReport = async (childId, parent = null) => {
  try {
    const child = await Child.findById(childId);
    
    if (!child) {
      throw new Error('Child not found');
    }
    
    if (!parent) {
      parent = await Parent.findById(child.parentId);
    }
    
    if (!parent || !parent.caregiverEmails || parent.caregiverEmails.length === 0) {
      console.log('No caregiver emails configured for this parent');
      return { success: false, message: 'No caregiver emails configured' };
    }
    
    // Get performance data for last 7 days
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    const records = await GameRecord.find({
      childId,
      createdAt: { $gte: sevenDaysAgo },
    });
    
    if (records.length === 0) {
      console.log('No game records found for this period');
      return { success: false, message: 'No activity in the past week' };
    }
    
    // Calculate statistics
    const totalSessions = records.length;
    const totalCorrect = records.reduce((sum, r) => sum + r.correctCount, 0);
    const totalAttempts = records.reduce((sum, r) => sum + r.attemptCount, 0);
    const accuracyPercent = Math.round((totalCorrect / totalAttempts) * 100);
    const avgTimeSeconds = Math.round(
      records.reduce((sum, r) => sum + r.durationMs, 0) / records.length / 1000
    );
    
    // Game statistics
    const gameStats = {};
    records.forEach(r => {
      if (!gameStats[r.gameName]) {
        gameStats[r.gameName] = {
          name: r.gameName,
          sessions: 0,
          totalScore: 0,
          avgScore: 0,
          bestScore: 0,
        };
      }
      gameStats[r.gameName].sessions++;
      gameStats[r.gameName].totalScore += r.score;
      gameStats[r.gameName].bestScore = Math.max(
        gameStats[r.gameName].bestScore,
        r.score
      );
    });
    
    Object.keys(gameStats).forEach(game => {
      gameStats[game].avgScore = Math.round(
        gameStats[game].totalScore / gameStats[game].sessions
      );
    });
    
    const gameStatsArray = Object.values(gameStats);
    
    // Get top performing game
    let topGame = 'N/A';
    let highestAvg = 0;
    gameStatsArray.forEach(game => {
      if (game.avgScore > highestAvg) {
        highestAvg = game.avgScore;
        topGame = game.name;
      }
    });
    
    // Generate AI suggestion
    let aiSuggestion = 'Keep up the great work! Consistent practice is helping build important skills.';
    try {
      // Only try to generate AI suggestion if Gemini is configured
      const { isAIConfigured } = await import('../config/gemini.js');
      if (isAIConfigured()) {
        const prompt = `
Based on this child's weekly performance, provide ONE encouraging insight and suggestion for caregivers (2-3 sentences).

Child: ${child.name}, Age: ${child.age}
Total sessions: ${totalSessions}
Accuracy: ${accuracyPercent}%
Games played: ${gameStatsArray.map(g => g.name).join(', ')}
Top game: ${topGame}

Be supportive, specific, and practical.
`;
        
        aiSuggestion = await generateAIResponse(prompt, {
          systemPrompt: 'You are an expert in autism education providing insights to caregivers.',
          temperature: 0.7,
          maxTokens: 150,
        });
      } else {
        console.log('OpenAI not configured - using default message');
      }
    } catch (error) {
      console.error('AI suggestion generation failed, using default:', error.message);
    }
    
    // Format date range
    const dateRange = `${sevenDaysAgo.toLocaleDateString()} - ${new Date().toLocaleDateString()}`;
    
    // Generate email HTML
    const emailHtml = generateEmailTemplate({
      childName: child.name,
      dateRange,
      totalSessions,
      accuracyPercent,
      avgTimeSeconds,
      topGame,
      chartImage: null, // Could add chart generation here
      aiSuggestion: aiSuggestion.trim(),
      dashboardUrl: `${process.env.FRONTEND_URL}/dashboard`,
      gameStats: gameStatsArray,
    });
    
    // Send email to all caregiver emails
    const results = [];
    for (const caregiver of parent.caregiverEmails) {
      const result = await sendEmail(
        caregiver.email,
        `BrightSteps Progress Report - ${child.name}`,
        emailHtml
      );
      results.push({
        email: caregiver.email,
        ...result,
      });
    }
    
    return {
      success: true,
      results,
    };
  } catch (error) {
    console.error('Error sending progress report:', error);
    return {
      success: false,
      error: error.message,
    };
  }
};

/**
 * Send progress report via API
 * POST /api/report/send
 */
export const sendReportAPI = async (req, res) => {
  try {
    const { childId } = req.body;
    
    console.log('📧 Send report request for child:', childId);
    
    // Verify child belongs to parent
    const child = await Child.findOne({
      _id: childId,
      parentId: req.parent._id,
    });
    
    if (!child) {
      console.log('❌ Child not found:', childId);
      return res.status(404).json({
        success: false,
        message: 'Child not found',
      });
    }
    
    console.log('✅ Child found:', child.name);
    console.log('📬 Caregiver emails:', req.parent.caregiverEmails?.length || 0);
    
    const result = await sendProgressReport(childId, req.parent);
    
    if (result.success) {
      console.log('✅ Report sent successfully');
      res.status(200).json({
        success: true,
        message: 'Report sent successfully',
        data: result.results,
      });
    } else {
      console.log('❌ Report send failed:', result.message || result.error);
      res.status(400).json({
        success: false,
        message: result.message || result.error || 'Failed to send report',
      });
    }
  } catch (error) {
    console.error('❌ Send report error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Preview report in browser
 * GET /api/report/preview/:childId
 */
export const previewReport = async (req, res) => {
  try {
    const { childId } = req.params;
    
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
    
    // Get performance data
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    const records = await GameRecord.find({
      childId,
      createdAt: { $gte: sevenDaysAgo },
    });
    
    // Calculate statistics (same as sendProgressReport)
    const totalSessions = records.length;
    const totalCorrect = records.reduce((sum, r) => sum + r.correctCount, 0);
    const totalAttempts = records.reduce((sum, r) => sum + r.attemptCount, 0);
    const accuracyPercent = totalAttempts > 0 ? Math.round((totalCorrect / totalAttempts) * 100) : 0;
    const avgTimeSeconds = records.length > 0 ? Math.round(
      records.reduce((sum, r) => sum + r.durationMs, 0) / records.length / 1000
    ) : 0;
    
    const gameStats = {};
    records.forEach(r => {
      if (!gameStats[r.gameName]) {
        gameStats[r.gameName] = {
          name: r.gameName,
          sessions: 0,
          totalScore: 0,
          avgScore: 0,
          bestScore: 0,
        };
      }
      gameStats[r.gameName].sessions++;
      gameStats[r.gameName].totalScore += r.score;
      gameStats[r.gameName].bestScore = Math.max(
        gameStats[r.gameName].bestScore,
        r.score
      );
    });
    
    Object.keys(gameStats).forEach(game => {
      gameStats[game].avgScore = Math.round(
        gameStats[game].totalScore / gameStats[game].sessions
      );
    });
    
    const gameStatsArray = Object.values(gameStats);
    let topGame = 'N/A';
    let highestAvg = 0;
    gameStatsArray.forEach(game => {
      if (game.avgScore > highestAvg) {
        highestAvg = game.avgScore;
        topGame = game.name;
      }
    });
    
    const dateRange = `${sevenDaysAgo.toLocaleDateString()} - ${new Date().toLocaleDateString()}`;
    
    // Generate HTML
    const emailHtml = generateEmailTemplate({
      childName: child.name,
      dateRange,
      totalSessions,
      accuracyPercent,
      avgTimeSeconds,
      topGame,
      chartImage: null,
      aiSuggestion: 'This is a preview. AI suggestions will be generated when sending actual reports.',
      dashboardUrl: `${process.env.FRONTEND_URL}/dashboard`,
      gameStats: gameStatsArray,
    });
    
    // Return HTML
    res.setHeader('Content-Type', 'text/html');
    res.send(emailHtml);
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};


/**
 * Generate HTML email template for caregiver reports
 * @param {Object} data - Report data
 * @returns {string} HTML email content
 */
export const generateEmailTemplate = (data) => {
  const {
    childName,
    dateRange,
    totalSessions,
    accuracyPercent,
    avgTimeSeconds,
    topGame,
    chartImage,
    aiSuggestion,
    dashboardUrl,
    gameStats,
  } = data;
  
  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BrightSteps Progress Report</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      line-height: 1.6;
      color: #333;
      background-color: #f4f7f9;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background-color: #ffffff;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px 20px;
      text-align: center;
    }
    .header h1 {
      margin: 0;
      font-size: 28px;
      font-weight: 600;
    }
    .header p {
      margin: 10px 0 0 0;
      opacity: 0.9;
      font-size: 14px;
    }
    .content {
      padding: 30px 20px;
    }
    .greeting {
      font-size: 18px;
      margin-bottom: 20px;
      color: #444;
    }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 15px;
      margin: 25px 0;
    }
    .stat-card {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      text-align: center;
      border: 1px solid #e9ecef;
    }
    .stat-value {
      font-size: 32px;
      font-weight: bold;
      color: #667eea;
      margin: 10px 0 5px 0;
    }
    .stat-label {
      font-size: 13px;
      color: #6c757d;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .section {
      margin: 30px 0;
    }
    .section-title {
      font-size: 20px;
      font-weight: 600;
      color: #2c3e50;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 2px solid #667eea;
    }
    .game-stats {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 8px;
      margin: 10px 0;
    }
    .game-name {
      font-weight: 600;
      color: #495057;
      margin-bottom: 8px;
    }
    .game-detail {
      font-size: 14px;
      color: #6c757d;
      margin: 5px 0;
    }
    .chart-container {
      text-align: center;
      margin: 20px 0;
    }
    .chart-container img {
      max-width: 100%;
      height: auto;
      border-radius: 8px;
    }
    .ai-section {
      background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
      padding: 20px;
      border-radius: 8px;
      margin: 25px 0;
    }
    .ai-title {
      font-size: 16px;
      font-weight: 600;
      color: #2c3e50;
      margin-bottom: 10px;
      display: flex;
      align-items: center;
    }
    .ai-icon {
      margin-right: 8px;
    }
    .ai-content {
      font-size: 14px;
      color: #2c3e50;
      line-height: 1.8;
    }
    .cta-button {
      display: inline-block;
      background: #667eea;
      color: white;
      padding: 14px 30px;
      text-decoration: none;
      border-radius: 6px;
      font-weight: 600;
      margin: 20px 0;
      transition: background 0.3s;
    }
    .cta-button:hover {
      background: #5568d3;
    }
    .footer {
      background: #f8f9fa;
      padding: 20px;
      text-align: center;
      font-size: 12px;
      color: #6c757d;
      border-top: 1px solid #e9ecef;
    }
    .footer-links {
      margin: 10px 0;
    }
    .footer-links a {
      color: #667eea;
      text-decoration: none;
      margin: 0 10px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🌟 BrightSteps Progress Report</h1>
      <p>${dateRange}</p>
    </div>
    
    <div class="content">
      <div class="greeting">
        Hello! Here's <strong>${childName}'s</strong> learning progress report 📊
      </div>
      
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-label">Total Sessions</div>
          <div class="stat-value">${totalSessions}</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Accuracy</div>
          <div class="stat-value">${accuracyPercent}%</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Avg Time</div>
          <div class="stat-value">${avgTimeSeconds}s</div>
        </div>
        <div class="stat-card">
          <div class="stat-label">Top Game</div>
          <div class="stat-value" style="font-size: 16px;">${topGame}</div>
        </div>
      </div>
      
      <div class="section">
        <div class="section-title">📈 Performance Overview</div>
        ${chartImage ? `
        <div class="chart-container">
          <img src="${chartImage}" alt="Performance Chart" />
        </div>
        ` : ''}
      </div>
      
      ${gameStats && gameStats.length > 0 ? `
      <div class="section">
        <div class="section-title">🎮 Game Statistics</div>
        ${gameStats.map(game => `
        <div class="game-stats">
          <div class="game-name">${game.name}</div>
          <div class="game-detail">Sessions: ${game.sessions} | Avg Score: ${game.avgScore} | Best: ${game.bestScore}</div>
        </div>
        `).join('')}
      </div>
      ` : ''}
      
      <div class="ai-section">
        <div class="ai-title">
          <span class="ai-icon">🤖</span>
          AI-Powered Insights
        </div>
        <div class="ai-content">
          ${aiSuggestion || 'Keep up the great work! Consistent practice is helping build important skills.'}
        </div>
      </div>
      
      <div style="text-align: center;">
        <a href="${dashboardUrl}" class="cta-button">View Full Dashboard</a>
      </div>
      
      <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e9ecef; font-size: 13px; color: #6c757d;">
        <p><strong>Tips for continued progress:</strong></p>
        <ul style="text-align: left; line-height: 1.8;">
          <li>Maintain a consistent daily practice schedule</li>
          <li>Celebrate small victories and progress</li>
          <li>Try different games to build various skills</li>
          <li>Keep the learning environment calm and positive</li>
        </ul>
      </div>
    </div>
    
    <div class="footer">
      <p>This report was automatically generated by BrightSteps</p>
      <div class="footer-links">
        <a href="${dashboardUrl}">Dashboard</a> |
        <a href="${dashboardUrl}/settings">Settings</a> |
        <a href="mailto:support@brightsteps.com">Support</a>
      </div>
      <p style="margin-top: 15px;">© 2025 BrightSteps. All rights reserved.</p>
    </div>
  </div>
</body>
</html>
  `;
};

export default generateEmailTemplate;


import cron from 'node-cron';
import Parent from '../models/Parent.js';
import Child from '../models/Child.js';
import Reminder from '../models/Reminder.js';
import { sendProgressReport } from '../controllers/emailController.js';

/**
 * Initialize all cron jobs
 */
export const initCronJobs = () => {
  // Check for scheduled reports every day at midnight
  cron.schedule('0 0 * * *', async () => {
    console.log('⏰ Running daily report check...');
    await checkAndSendReports();
  });
  
  // Check for reminders every minute
  cron.schedule('* * * * *', async () => {
    await checkReminders();
  });
  
  console.log('✅ Cron jobs initialized');
};

/**
 * Check and send scheduled reports based on frequency
 */
const checkAndSendReports = async () => {
  try {
    const now = new Date();
    const parents = await Parent.find({ reportFrequency: { $ne: 'none' } });
    
    for (const parent of parents) {
      let shouldSend = false;
      
      if (!parent.lastReportSent) {
        shouldSend = true;
      } else {
        const daysSinceLastReport = Math.floor(
          (now - parent.lastReportSent) / (1000 * 60 * 60 * 24)
        );
        
        switch (parent.reportFrequency) {
          case 'daily':
            shouldSend = daysSinceLastReport >= 1;
            break;
          case 'weekly':
            shouldSend = daysSinceLastReport >= 7;
            break;
          case 'monthly':
            shouldSend = daysSinceLastReport >= 30;
            break;
        }
      }
      
      if (shouldSend) {
        // Get all children for this parent
        const children = await Child.find({ parentId: parent._id });
        
        for (const child of children) {
          await sendProgressReport(child._id, parent);
        }
        
        // Update last report sent time
        parent.lastReportSent = now;
        await parent.save();
      }
    }
  } catch (error) {
    console.error('Error in checkAndSendReports:', error);
  }
};

/**
 * Check for active reminders that should trigger now
 */
const checkReminders = async () => {
  try {
    const now = new Date();
    const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
    const currentDay = now.getDay();
    
    const reminders = await Reminder.find({
      enabled: true,
      time: currentTime,
      $or: [
        { daysOfWeek: { $size: 0 } },
        { daysOfWeek: currentDay }
      ]
    }).populate('childId');
    
    // Note: In production, you would emit events via WebSocket or push notifications
    // For now, we'll just log them
    if (reminders.length > 0) {
      console.log(`🔔 ${reminders.length} reminder(s) triggered at ${currentTime}`);
      reminders.forEach(reminder => {
        console.log(`  - ${reminder.type} for ${reminder.childId?.name}: ${reminder.title}`);
      });
    }
  } catch (error) {
    console.error('Error in checkReminders:', error);
  }
};

export default initCronJobs;


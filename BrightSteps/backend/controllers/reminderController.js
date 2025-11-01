import Reminder from '../models/Reminder.js';
import Child from '../models/Child.js';

/**
 * Create a new reminder
 * POST /api/reminders
 */
export const createReminder = async (req, res) => {
  try {
    const { childId, type, time, title, message, songLyrics, daysOfWeek } = req.body;
    
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
    
    const reminder = await Reminder.create({
      childId,
      type,
      time,
      title,
      message,
      songLyrics,
      daysOfWeek: daysOfWeek || [],
    });
    
    res.status(201).json({
      success: true,
      data: reminder,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get all reminders for a child
 * GET /api/reminders/:childId
 */
export const getReminders = async (req, res) => {
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
    
    const reminders = await Reminder.find({ childId }).sort({ time: 1 });
    
    res.status(200).json({
      success: true,
      count: reminders.length,
      data: reminders,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Update a reminder
 * PUT /api/reminders/:id
 */
export const updateReminder = async (req, res) => {
  try {
    const { id } = req.params;
    const { type, time, title, message, songLyrics, enabled, daysOfWeek } = req.body;
    
    // Find reminder and verify ownership
    const reminder = await Reminder.findById(id).populate('childId');
    
    if (!reminder) {
      return res.status(404).json({
        success: false,
        message: 'Reminder not found',
      });
    }
    
    if (reminder.childId.parentId.toString() !== req.parent._id.toString()) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this reminder',
      });
    }
    
    const updates = {
      type,
      time,
      title,
      message,
      songLyrics,
      enabled,
      daysOfWeek,
    };
    
    // Remove undefined fields
    Object.keys(updates).forEach(key => 
      updates[key] === undefined && delete updates[key]
    );
    
    const updatedReminder = await Reminder.findByIdAndUpdate(
      id,
      updates,
      { new: true, runValidators: true }
    );
    
    res.status(200).json({
      success: true,
      data: updatedReminder,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Delete a reminder
 * DELETE /api/reminders/:id
 */
export const deleteReminder = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Find reminder and verify ownership
    const reminder = await Reminder.findById(id).populate('childId');
    
    if (!reminder) {
      return res.status(404).json({
        success: false,
        message: 'Reminder not found',
      });
    }
    
    if (reminder.childId.parentId.toString() !== req.parent._id.toString()) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to delete this reminder',
      });
    }
    
    await Reminder.findByIdAndDelete(id);
    
    res.status(200).json({
      success: true,
      message: 'Reminder deleted successfully',
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get active reminders (for child app)
 * GET /api/reminders/active/:childId
 */
export const getActiveReminders = async (req, res) => {
  try {
    const { childId } = req.params;
    const now = new Date();
    const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
    const currentDay = now.getDay();
    
    console.log(`🔔 Checking active reminders for child ${childId} at ${currentTime} (day ${currentDay})`);
    
    const reminders = await Reminder.find({
      childId,
      enabled: true,
      time: currentTime,
      $or: [
        { daysOfWeek: { $size: 0 } },
        { daysOfWeek: currentDay }
      ]
    });
    
    console.log(`📋 Found ${reminders.length} active reminder(s)`);
    if (reminders.length > 0) {
      console.log('Reminder details:', reminders[0]);
    }
    
    res.status(200).json({
      success: true,
      data: reminders,
    });
  } catch (error) {
    console.error('❌ Error in getActiveReminders:', error);
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};


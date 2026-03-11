import express from 'express';
import {
  createReminder,
  getReminders,
  updateReminder,
  deleteReminder,
  getActiveReminders,
} from '../controllers/reminderController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

// Protected routes
router.post('/', protect, createReminder);
router.get('/:childId', protect, getReminders);
router.put('/:id', protect, updateReminder);
router.delete('/:id', protect, deleteReminder);

// Public route for child app to check reminders
router.get('/active/:childId', getActiveReminders);

export default router;


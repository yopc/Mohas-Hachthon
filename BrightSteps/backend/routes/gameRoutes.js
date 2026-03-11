import express from 'express';
import {
  saveGameRecord,
  getGameRecords,
  getProgress,
  getDailyStats,
} from '../controllers/gameController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

// All routes are protected
router.use(protect);

router.post('/record', saveGameRecord);
router.get('/records/:childId', getGameRecords);
router.get('/progress/:childId', getProgress);
router.get('/daily-stats/:childId', getDailyStats);

export default router;


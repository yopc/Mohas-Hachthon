import express from 'express';
import {
  getAdaptiveRecommendation,
  generateSongLyrics,
  generateMotivation,
  generateParentTip,
} from '../controllers/aiController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

// All routes are protected
router.use(protect);

router.post('/adapt', getAdaptiveRecommendation);
router.post('/song', generateSongLyrics);
router.post('/motivate', generateMotivation);
router.post('/parent-tip', generateParentTip);

export default router;


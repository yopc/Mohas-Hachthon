import express from 'express';
import { isAIConfigured } from '../config/gemini.js';

const router = express.Router();

router.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'BrightSteps API is running',
    timestamp: new Date().toISOString(),
    features: {
      ai: isAIConfigured(),
      email: !!(process.env.SMTP_USER && process.env.SMTP_PASS),
      mongodb: true,
    },
  });
});

export default router;


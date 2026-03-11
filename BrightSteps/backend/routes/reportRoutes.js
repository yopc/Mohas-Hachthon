import express from 'express';
import { sendReportAPI, previewReport } from '../controllers/emailController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

// All routes are protected
router.use(protect);

router.post('/send', sendReportAPI);
router.get('/preview/:childId', previewReport);

export default router;


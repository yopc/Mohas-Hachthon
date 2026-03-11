import express from 'express';
import {
  createChild,
  getChildren,
  getChild,
  updateChild,
  deleteChild,
} from '../controllers/childController.js';
import { protect } from '../middleware/auth.js';
import upload from '../config/multer.js';

const router = express.Router();

// All routes are protected
router.use(protect);

router.post('/', upload.single('avatar'), createChild);
router.get('/', getChildren);
router.get('/:id', getChild);
router.put('/:id', upload.single('avatar'), updateChild);
router.delete('/:id', deleteChild);

export default router;


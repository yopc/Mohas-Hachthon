import Child from '../models/Child.js';
import { bufferToBase64 } from '../config/multer.js';

/**
 * Create a new child profile
 * POST /api/children
 */
export const createChild = async (req, res) => {
  try {
    const { name, age, preferredDifficulty, interests, notes } = req.body;
    
    let avatar = null;
    
    // Handle avatar upload if present
    if (req.file) {
      avatar = bufferToBase64(req.file.buffer, req.file.mimetype);
    }
    
    const child = await Child.create({
      name,
      age,
      avatar,
      parentId: req.parent._id,
      preferredDifficulty,
      interests: interests ? JSON.parse(interests) : [],
      notes,
    });
    
    res.status(201).json({
      success: true,
      data: child,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get all children for current parent
 * GET /api/children
 */
export const getChildren = async (req, res) => {
  try {
    const children = await Child.find({ parentId: req.parent._id });
    
    res.status(200).json({
      success: true,
      count: children.length,
      data: children,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get single child by ID
 * GET /api/children/:id
 */
export const getChild = async (req, res) => {
  try {
    const child = await Child.findOne({
      _id: req.params.id,
      parentId: req.parent._id,
    });
    
    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found',
      });
    }
    
    res.status(200).json({
      success: true,
      data: child,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Update child profile
 * PUT /api/children/:id
 */
export const updateChild = async (req, res) => {
  try {
    const { name, age, preferredDifficulty, interests, notes } = req.body;
    
    const updates = {
      name,
      age,
      preferredDifficulty,
      interests: interests ? JSON.parse(interests) : undefined,
      notes,
    };
    
    // Handle avatar upload if present
    if (req.file) {
      updates.avatar = bufferToBase64(req.file.buffer, req.file.mimetype);
    }
    
    // Remove undefined fields
    Object.keys(updates).forEach(key => 
      updates[key] === undefined && delete updates[key]
    );
    
    const child = await Child.findOneAndUpdate(
      { _id: req.params.id, parentId: req.parent._id },
      updates,
      { new: true, runValidators: true }
    );
    
    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found',
      });
    }
    
    res.status(200).json({
      success: true,
      data: child,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Delete child profile
 * DELETE /api/children/:id
 */
export const deleteChild = async (req, res) => {
  try {
    const child = await Child.findOneAndDelete({
      _id: req.params.id,
      parentId: req.parent._id,
    });
    
    if (!child) {
      return res.status(404).json({
        success: false,
        message: 'Child not found',
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Child deleted successfully',
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};


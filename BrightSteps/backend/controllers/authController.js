import Parent from '../models/Parent.js';
import { generateToken } from '../middleware/auth.js';

/**
 * Register a new parent
 * POST /api/auth/register
 */
export const register = async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;
    
    // Check if parent already exists
    const existingParent = await Parent.findOne({ email });
    if (existingParent) {
      return res.status(400).json({
        success: false,
        message: 'Email already registered',
      });
    }
    
    // Create parent
    const parent = await Parent.create({
      name,
      email,
      password,
      phone,
    });
    
    // Generate token
    const token = generateToken(parent._id);
    
    res.status(201).json({
      success: true,
      data: {
        parent: {
          id: parent._id,
          name: parent.name,
          email: parent.email,
          phone: parent.phone,
        },
        token,
      },
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Login parent
 * POST /api/auth/login
 */
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Validate input
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide email and password',
      });
    }
    
    // Find parent (including password field)
    const parent = await Parent.findOne({ email }).select('+password');
    
    if (!parent) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }
    
    // Check password
    const isPasswordCorrect = await parent.comparePassword(password);
    
    if (!isPasswordCorrect) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }
    
    // Generate token
    const token = generateToken(parent._id);
    
    res.status(200).json({
      success: true,
      data: {
        parent: {
          id: parent._id,
          name: parent.name,
          email: parent.email,
          phone: parent.phone,
          caregiverEmails: parent.caregiverEmails,
          reportFrequency: parent.reportFrequency,
        },
        token,
      },
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Get current parent profile
 * GET /api/auth/me
 */
export const getMe = async (req, res) => {
  try {
    const parent = await Parent.findById(req.parent._id);
    
    res.status(200).json({
      success: true,
      data: parent,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Update parent profile
 * PUT /api/auth/me
 */
export const updateProfile = async (req, res) => {
  try {
    const updates = {
      name: req.body.name,
      phone: req.body.phone,
      caregiverEmails: req.body.caregiverEmails,
      reportFrequency: req.body.reportFrequency,
    };
    
    // Remove undefined fields
    Object.keys(updates).forEach(key => 
      updates[key] === undefined && delete updates[key]
    );
    
    const parent = await Parent.findByIdAndUpdate(
      req.parent._id,
      updates,
      { new: true, runValidators: true }
    );
    
    res.status(200).json({
      success: true,
      data: parent,
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      message: error.message,
    });
  }
};


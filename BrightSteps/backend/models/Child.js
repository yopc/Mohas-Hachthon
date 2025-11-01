import mongoose from 'mongoose';

const childSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Please provide child name'],
    trim: true,
  },
  age: {
    type: Number,
    required: [true, 'Please provide child age'],
    min: 1,
    max: 18,
  },
  avatar: {
    type: String, // Base64 encoded image
    default: null,
  },
  parentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Parent',
    required: true,
  },
  preferredDifficulty: {
    type: String,
    enum: ['easy', 'medium', 'hard'],
    default: 'easy',
  },
  interests: [{
    type: String,
  }],
  notes: {
    type: String,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
});

// Index for faster queries
childSchema.index({ parentId: 1 });

const Child = mongoose.model('Child', childSchema);

export default Child;


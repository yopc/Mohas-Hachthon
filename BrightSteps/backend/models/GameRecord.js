import mongoose from 'mongoose';

const gameRecordSchema = new mongoose.Schema({
  childId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Child',
    required: true,
  },
  gameName: {
    type: String,
    required: true,
    enum: ['shape-match', 'sound-match', 'memory-puzzle'],
  },
  level: {
    type: String,
    required: true,
    enum: ['easy', 'medium', 'hard'],
  },
  startTime: {
    type: Date,
    required: true,
  },
  endTime: {
    type: Date,
    required: true,
  },
  durationMs: {
    type: Number,
    required: true,
  },
  correctCount: {
    type: Number,
    required: true,
    default: 0,
  },
  attemptCount: {
    type: Number,
    required: true,
    default: 0,
  },
  mistakes: {
    type: Number,
    default: 0,
  },
  score: {
    type: Number,
    default: 0,
  },
  additionalData: {
    type: mongoose.Schema.Types.Mixed,
    default: {},
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
});

// Indexes for faster queries
gameRecordSchema.index({ childId: 1, createdAt: -1 });
gameRecordSchema.index({ childId: 1, gameName: 1 });

// Calculate score before saving
gameRecordSchema.pre('save', function(next) {
  if (this.isNew) {
    const levelBonus = {
      easy: 10,
      medium: 20,
      hard: 30,
    };
    
    const accuracy = this.attemptCount > 0 
      ? (this.correctCount / this.attemptCount) * 100 
      : 0;
    
    this.score = Math.max(0, 
      accuracy + 
      levelBonus[this.level] - 
      (this.mistakes * 2)
    );
  }
  next();
});

const GameRecord = mongoose.model('GameRecord', gameRecordSchema);

export default GameRecord;


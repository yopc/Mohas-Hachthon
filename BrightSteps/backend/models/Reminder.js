import mongoose from 'mongoose';

const reminderSchema = new mongoose.Schema({
  childId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Child',
    required: true,
  },
  type: {
    type: String,
    required: true,
    enum: ['breakfast', 'lunch', 'dinner', 'snack', 'custom'],
  },
  time: {
    type: String, // Format: "HH:mm" (24-hour)
    required: true,
    validate: {
      validator: function(v) {
        return /^([01]\d|2[0-3]):([0-5]\d)$/.test(v);
      },
      message: 'Time must be in HH:mm format',
    },
  },
  title: {
    type: String,
    required: true,
  },
  message: {
    type: String,
  },
  songLyrics: {
    type: String,
  },
  audioFile: {
    type: String, // Base64 encoded audio
  },
  enabled: {
    type: Boolean,
    default: true,
  },
  daysOfWeek: [{
    type: Number,
    min: 0,
    max: 6, // 0 = Sunday, 6 = Saturday
  }],
  createdAt: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
});

// Index for faster queries
reminderSchema.index({ childId: 1, enabled: 1 });

const Reminder = mongoose.model('Reminder', reminderSchema);

export default Reminder;


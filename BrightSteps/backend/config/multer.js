import multer from 'multer';

// Store files in memory as Buffer objects
const storage = multer.memoryStorage();

// File filter to accept only images
const fileFilter = (req, file, cb) => {
  if (file.mimetype.startsWith('image/')) {
    cb(null, true);
  } else {
    cb(new Error('Only image files are allowed'), false);
  }
};

// Create multer instance
const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
});

// Helper function to convert buffer to base64
export const bufferToBase64 = (buffer, mimeType) => {
  const base64 = buffer.toString('base64');
  return `data:${mimeType};base64,${base64}`;
};

export default upload;


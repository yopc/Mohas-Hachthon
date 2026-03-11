import { GoogleGenerativeAI } from '@google/generative-ai';

// Check if Gemini API key is available
const hasGeminiKey = process.env.GEMINI_API_KEY && process.env.GEMINI_API_KEY.length > 10;

let genAI = null;
let model = null;

if (hasGeminiKey) {
  genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
  model = genAI.getGenerativeModel({ model: 'gemini-pro' });
  console.log('✅ Google Gemini AI configured');
} else {
  console.log('⚠️  Gemini API key not configured - AI features will be disabled');
}

/**
 * Generate AI response using Gemini
 * @param {string} prompt - The prompt to send to Gemini
 * @param {object} options - Optional configuration
 * @returns {Promise<string>} AI-generated response
 */
export const generateAIResponse = async (prompt, options = {}) => {
  if (!model) {
    throw new Error('Gemini API is not configured. Please add GEMINI_API_KEY to your .env file.');
  }
  
  try {
    const systemPrompt = options.systemPrompt || 'You are a helpful assistant specialized in autism education and child development.';
    const fullPrompt = `${systemPrompt}\n\n${prompt}`;
    
    const result = await model.generateContent(fullPrompt);
    const response = await result.response;
    const text = response.text();
    
    return text;
  } catch (error) {
    console.error('❌ Gemini API Error:', error);
    throw new Error('Failed to generate AI response: ' + error.message);
  }
};

/**
 * Generate JSON response using Gemini
 * @param {string} prompt - The prompt to send to Gemini
 * @param {object} options - Optional configuration
 * @returns {Promise<object>} Parsed JSON response
 */
export const generateJSON = async (prompt, options = {}) => {
  if (!model) {
    throw new Error('Gemini API is not configured. Please add GEMINI_API_KEY to your .env file.');
  }
  
  try {
    const systemPrompt = options.systemPrompt || 'You are a helpful assistant. Always respond with valid JSON only, no other text.';
    const fullPrompt = `${systemPrompt}\n\n${prompt}\n\nIMPORTANT: Respond ONLY with valid JSON, no markdown, no code blocks, just pure JSON.`;
    
    const result = await model.generateContent(fullPrompt);
    const response = await result.response;
    let text = response.text();
    
    // Clean up response - remove markdown code blocks if present
    text = text.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();
    
    return JSON.parse(text);
  } catch (error) {
    console.error('❌ Gemini JSON Error:', error);
    throw new Error('Failed to generate JSON response: ' + error.message);
  }
};

/**
 * Check if Gemini is configured
 * @returns {boolean}
 */
export const isAIConfigured = () => hasGeminiKey;

export default genAI;


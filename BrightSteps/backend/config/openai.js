import OpenAI from 'openai';

// Check if OpenAI API key is available
const hasOpenAIKey = process.env.OPENAI_API_KEY && process.env.OPENAI_API_KEY.startsWith('sk-');

let openai = null;

if (hasOpenAIKey) {
  openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });
  console.log('✅ OpenAI API configured');
} else {
  console.log('⚠️  OpenAI API key not configured - AI features will be disabled');
}

export const generateAIResponse = async (prompt, options = {}) => {
  if (!openai) {
    throw new Error('OpenAI API is not configured. Please add OPENAI_API_KEY to your .env file.');
  }
  
  try {
    const completion = await openai.chat.completions.create({
      model: options.model || 'gpt-3.5-turbo',
      messages: [
        {
          role: 'system',
          content: options.systemPrompt || 'You are a helpful assistant specialized in autism education and child development.',
        },
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: options.temperature || 0.7,
      max_tokens: options.maxTokens || 500,
    });
    
    return completion.choices[0].message.content;
  } catch (error) {
    console.error('❌ OpenAI API Error:', error);
    throw new Error('Failed to generate AI response');
  }
};

export const generateJSON = async (prompt, options = {}) => {
  if (!openai) {
    throw new Error('OpenAI API is not configured. Please add OPENAI_API_KEY to your .env file.');
  }
  
  try {
    const completion = await openai.chat.completions.create({
      model: options.model || 'gpt-3.5-turbo',
      messages: [
        {
          role: 'system',
          content: options.systemPrompt || 'You are a helpful assistant. Always respond with valid JSON.',
        },
        {
          role: 'user',
          content: prompt,
        },
      ],
      temperature: options.temperature || 0.7,
      max_tokens: options.maxTokens || 500,
      response_format: { type: 'json_object' },
    });
    
    return JSON.parse(completion.choices[0].message.content);
  } catch (error) {
    console.error('❌ OpenAI JSON Error:', error);
    throw new Error('Failed to generate JSON response');
  }
};

export const isOpenAIConfigured = () => hasOpenAIKey;

export default openai;


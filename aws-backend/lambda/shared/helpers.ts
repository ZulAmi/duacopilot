// Helper functions for Lambda handlers
import { v4 as uuidv4 } from 'uuid';
import { DatabaseService } from './lambda-adapter';

// Generate unique ID
export const generateId = (): string => uuidv4();

// Build Islamic system prompt
export const buildIslamicSystemPrompt = (userPrefs: any, language: string): string => {
  const basePrompt = `You are DuaCopilot, an Islamic AI assistant dedicated to providing accurate Islamic guidance based on the Quran and authentic Hadith. 

Key principles:
- Always base responses on authentic Islamic sources
- Provide references from Quran and Hadith when possible  
- Be respectful of all Islamic schools of thought
- Encourage consulting local scholars for complex matters
- Use appropriate Islamic greetings and language
- Prioritize spiritual guidance and Islamic values

Language: ${language}
User preferences: ${JSON.stringify(userPrefs)}

Provide helpful, accurate, and Islamically-sound responses.`;

  return basePrompt;
};

// Get conversation history from DynamoDB
export const getConversationHistory = async (conversationId: string, userId: string): Promise<any[]> => {
  if (!conversationId) return [];
  
  try {
    const messages = await DatabaseService.queryDocuments(
      process.env.CONVERSATION_TABLE!,
      {
        KeyConditionExpression: 'conversationId = :cid',
        ExpressionAttributeValues: {
          ':cid': conversationId,
          ':uid': userId,
        },
        FilterExpression: 'userId = :uid',
        ScanIndexForward: true,
        Limit: 20, // Last 20 messages
      }
    );
    
    return messages.map((msg: any) => ({
      role: msg.role || 'user',
      content: msg.content || '',
    }));
  } catch (error) {
    console.error('Error fetching conversation history:', error);
    return [];
  }
};

// Save conversation message
export const saveConversation = async (
  conversationId: string, 
  userId: string, 
  userMessage: string, 
  aiResponse: string
): Promise<void> => {
  const timestamp = Date.now();
  
  try {
    // Save user message
    await DatabaseService.putDocument(process.env.CONVERSATION_TABLE!, {
      conversationId,
      messageId: generateId(),
      userId,
      role: 'user',
      content: userMessage,
      timestamp,
      createdAt: new Date().toISOString(),
    });
    
    // Save AI response
    await DatabaseService.putDocument(process.env.CONVERSATION_TABLE!, {
      conversationId,
      messageId: generateId(),
      userId,
      role: 'assistant',
      content: aiResponse,
      timestamp: timestamp + 1,
      createdAt: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Error saving conversation:', error);
    throw error;
  }
};

// Extract citations from AI response
export const extractCitations = async (response: string): Promise<any[]> => {
  const citations: any[] = [];
  
  // Simple citation extraction (can be enhanced)
  const quranPattern = /Quran\s+(\d+:\d+)/gi;
  const hadithPattern = /Hadith.*?(Bukhari|Muslim|Tirmidhi|Abu Dawud|Nasa'i|Ibn Majah)/gi;
  
  let match;
  
  // Extract Quran references
  while ((match = quranPattern.exec(response)) !== null) {
    citations.push({
      type: 'quran',
      reference: match[1],
      text: match[0],
    });
  }
  
  // Extract Hadith references  
  while ((match = hadithPattern.exec(response)) !== null) {
    citations.push({
      type: 'hadith',
      collection: match[1],
      text: match[0],
    });
  }
  
  return citations;
};

// Islamic content helpers
export const getPrayerTimes = async (latitude: number, longitude: number, date?: string) => {
  // Implementation for prayer times calculation
  // This would integrate with an Islamic prayer times API
  return {
    fajr: '05:30',
    sunrise: '06:45',
    dhuhr: '12:30',
    asr: '15:45',
    maghrib: '18:15',
    isha: '19:30',
  };
};

export const searchQuranVerses = async (query: string, language = 'en') => {
  // Implementation for Quran search
  // This would search through indexed Quran verses
  return [];
};

export const getDuasByCategory = async (category: string, language = 'en') => {
  // Implementation for getting duas by category
  return [];
};

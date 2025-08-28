// AWS Lambda Handlers - Migrated from Firebase Functions
// This file adapts your Firebase Functions for AWS Lambda

import { DatabaseService, HttpsError, lambdaWrapper, serverTimestamp } from './lambda-adapter';

// Import OpenAI
import { OpenAI } from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

// AI Services - Migrated from firebase/functions/src/ai-services/index.ts
export const aiChat = lambdaWrapper(async (data: any, context: any) => {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { message, conversationId, language = 'en' } = data;
  const userId = context.auth.uid;

  try {
    // Get user preferences from DynamoDB (replaces Firestore)
    const userDoc = await DatabaseService.getDocument(
      process.env.USER_TABLE!,
      { userId }
    );
    const userPrefs = userDoc?.preferences || {};

    // Build system prompt with Islamic context (same as Firebase)
    const systemPrompt = buildIslamicSystemPrompt(userPrefs, language);
    
    // Get conversation history from DynamoDB
    const history = await getConversationHistory(conversationId, userId);
    
    // Generate AI response using OpenAI
    const completion = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        { role: "system", content: systemPrompt },
        ...history,
        { role: "user", content: message }
      ],
      temperature: 0.7,
      max_tokens: 2000
    });

    const response = completion.choices[0].message.content || '';

    // Save conversation to DynamoDB
    await saveConversation(conversationId || generateId(), userId, message, response || '');

    return {
      response,
      conversationId: conversationId || generateId(),
      citations: await extractCitations(response)
    };
  } catch (error) {
    console.error('AI Chat error:', error);
    throw new HttpsError('internal', 'Failed to process AI chat request');
  }
});

export const classifyIntent = lambdaWrapper(async (data: any, context: any) => {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { query } = data;
  const intents = [
    'dua_request', 'quran_verse', 'prayer_times', 'islamic_question',
    'hadith_search', 'general_question'
  ];

  try {
    const completion = await openai.chat.completions.create({
      model: 'gpt-3.5-turbo',
      messages: [
        {
          role: "system",
          content: `Classify the following query into one of these categories: ${intents.join(', ')}. Respond with only the category name.`
        },
        {
          role: "user",
          content: query
        }
      ],
      temperature: 0.3,
      max_tokens: 50
    });

    const intent = completion.choices[0].message.content?.toLowerCase().trim();

    return {
      intent: intents.includes(intent!) ? intent : 'general_question',
      confidence: 0.85
    };
  } catch (error) {
    console.error('Intent classification error:', error);
    throw new HttpsError('internal', 'Failed to classify intent');
  }
});

// Authentication - Migrated from firebase/functions/src/auth/index.ts
export const createUser = lambdaWrapper(async (data: any, context: any) => {
  const { email, password, displayName } = data;
  
  try {
    // Generate unique user ID
    const userId = `user_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    
    // Create user profile in DynamoDB
    const userProfile = {
      userId,
      email,
      displayName: displayName || '',
      photoURL: '',
      createdAt: serverTimestamp(),
      lastLogin: serverTimestamp(),
      preferences: {
        language: 'en',
        notifications: true,
        theme: 'light',
        culturalRegion: 'general',
        prayerMethod: 'MWL',
        madhab: 'general'
      },
      subscription: {
        plan: 'free',
        status: 'active',
        expiryDate: null
      },
      statistics: {
        duasRead: 0,
        versesRead: 0,
        hadithRead: 0,
        tasbihCount: 0,
        streak: 0
      }
    };

    await DatabaseService.putDocument(process.env.USER_TABLE!, userProfile);

    // Generate JWT token
    const jwt = require('jsonwebtoken');
    const token = jwt.sign(
      { 
        uid: userId, 
        email,
        admin: false,
        premium: false 
      },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    return { success: true, userId, token };
  } catch (error) {
    console.error('Error creating user profile:', error);
    throw new HttpsError('internal', 'Failed to create user profile');
  }
});

// Islamic Content - Migrated from firebase/functions/src/islamic-content/index.ts
export const getDuas = lambdaWrapper(async (data: any, context: any) => {
  const { category, emotion, context: duaContext, language = 'en', limit = 20 } = data;
  
  try {
    // Query DynamoDB for duas (you'll need to populate this data)
    const queryParams = {
      TableName: 'duas', // You'll need to create this table
      Limit: limit
    };

    const duas = await DatabaseService.queryDocuments('duas', queryParams);
    
    return { duas };
  } catch (error) {
    console.error('Error getting duas:', error);
    throw new HttpsError('internal', 'Failed to get duas');
  }
});

// Analytics - Migrated from firebase/functions/src/analytics/index.ts
export const logEvent = lambdaWrapper(async (data: any, context: any) => {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { eventName, parameters } = data;
  const userId = context.auth.uid;

  const event = {
    eventId: `${userId}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    userId,
    eventName,
    parameters,
    timestamp: Date.now(),
    platform: parameters.platform || 'unknown',
    appVersion: parameters.appVersion || 'unknown'
  };

  // Store in DynamoDB
  await DatabaseService.putDocument(process.env.ANALYTICS_TABLE!, event);

  return { success: true };
});

// Helper functions (same logic as Firebase)
function buildIslamicSystemPrompt(userPrefs: any, language: string) {
  return `You are an Islamic AI assistant. Provide helpful, accurate responses based on Islamic teachings. 
  User preferences: ${JSON.stringify(userPrefs)}. Language: ${language}`;
}

async function getConversationHistory(conversationId: string, userId: string) {
  if (!conversationId) return [];
  
  const messages = await DatabaseService.queryDocuments(process.env.CONVERSATION_TABLE!, {
    KeyConditionExpression: 'conversationId = :cid',
    ExpressionAttributeValues: { ':cid': conversationId },
    ScanIndexForward: true,
    Limit: 10
  });
  
  return messages.map((msg: any) => ({
    role: msg.role,
    content: msg.content
  }));
}

async function saveConversation(conversationId: string, userId: string, userMessage: string, aiResponse: string) {
  // Save conversation metadata
  await DatabaseService.putDocument(process.env.CONVERSATION_TABLE!, {
    conversationId,
    userId,
    lastMessage: serverTimestamp(),
    messageCount: 2 // This would need proper increment logic
  });

  // Save individual messages (simplified - you'd want a messages table)
  const messages = [
    {
      messageId: `${conversationId}_${Date.now()}_user`,
      conversationId,
      role: 'user',
      content: userMessage,
      timestamp: serverTimestamp()
    },
    {
      messageId: `${conversationId}_${Date.now()}_assistant`,
      conversationId,
      role: 'assistant',
      content: aiResponse,
      timestamp: serverTimestamp()
    }
  ];

  for (const message of messages) {
    await DatabaseService.putDocument('messages', message);
  }
}

async function extractCitations(text: string) {
  // Same citation logic as Firebase
  return [];
}

function generateId() {
  return `${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
}

// AI Services Lambda Functions
import { OpenAI } from 'openai';
import { buildIslamicSystemPrompt, extractCitations, generateId, getConversationHistory, saveConversation } from './shared/helpers';
import { DatabaseService, HttpsError, lambdaWrapper } from './shared/lambda-adapter';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

export const aiChat = lambdaWrapper(async (data: any, context: any) => {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { message, conversationId, language = 'en' } = data;
  const userId = context.auth.uid;

  try {
    // Get user preferences from DynamoDB
    const userDoc = await DatabaseService.getDocument(
      process.env.USER_TABLE!,
      { userId }
    );
    const userPrefs = userDoc?.preferences || {};

    // Build system prompt with Islamic context
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

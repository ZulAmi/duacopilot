import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { OpenAI } from 'openai';

const db = admin.firestore();
const openai = new OpenAI({
  apiKey: functions.config().openai.key
});

// AI Chat endpoint
export const aiChat = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { message, conversationId, language = 'en', context: chatContext } = data;
  const userId = context.auth.uid;

  try {
    // Get user preferences
    const userDoc = await db.collection('users').doc(userId).get();
    const userPrefs = userDoc.data()?.preferences || {};

    // Build system prompt with Islamic context
    const systemPrompt = buildIslamicSystemPrompt(userPrefs, language);
    
    // Get conversation history
    const history = await getConversationHistory(conversationId, userId);
    
    // Generate AI response
    const completion = await openai.chat.completions.create({
      model: "gpt-4",
      messages: [
        { role: "system", content: systemPrompt },
        ...history,
        { role: "user", content: message }
      ],
      temperature: 0.7,
      max_tokens: 500
    });

    const aiResponse = completion.choices[0].message.content;

    // Save to conversation history
    await saveConversation(conversationId, userId, message, aiResponse);

    // Extract any Quranic/Hadith references for citation
    const citations = await extractCitations(aiResponse);

    return {
      response: aiResponse,
      citations,
      conversationId
    };
  } catch (error) {
    console.error('AI Chat error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to generate AI response');
  }
});

// Generate embeddings for semantic search
export const generateEmbeddings = functions.https.onCall(async (data, context) => {
  const { text, language = 'en' } = data;

  try {
    const embedding = await openai.embeddings.create({
      model: "text-embedding-ada-002",
      input: text
    });

    return {
      embedding: embedding.data[0].embedding,
      model: "text-embedding-ada-002"
    };
  } catch (error) {
    console.error('Embedding generation error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to generate embeddings');
  }
});

// Classify intent
export const classifyIntent = functions.https.onCall(async (data, context) => {
  const { query, language = 'en' } = data;

  const intents = [
    'dua_request',
    'quran_query',
    'hadith_search',
    'prayer_time',
    'islamic_ruling',
    'general_question'
  ];

  try {
    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: `Classify the following Islamic query into one of these intents: ${intents.join(', ')}`
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
    throw new functions.https.HttpsError('internal', 'Failed to classify intent');
  }
});

// Helper functions
function buildIslamicSystemPrompt(userPrefs: any, language: string) {
  return `You are DuaCopilot, an Islamic AI assistant. You provide authentic Islamic guidance based on Quran and Sunnah.
  
  User preferences:
  - Language: ${language}
  - Madhab: ${userPrefs.madhab || 'general'}
  - Cultural region: ${userPrefs.culturalRegion || 'general'}
  
  Guidelines:
  - Always cite Quranic verses and authentic Hadith when applicable
  - Be respectful and use Islamic etiquette (e.g., "Peace be upon him" after Prophet's name)
  - Provide balanced views when there are different scholarly opinions
  - Avoid controversial topics unless specifically asked
  - If unsure, recommend consulting local Islamic scholars`;
}

async function getConversationHistory(conversationId: string, userId: string) {
  if (!conversationId) return [];
  
  const snapshot = await db
    .collection('conversations')
    .doc(conversationId)
    .collection('messages')
    .orderBy('timestamp', 'asc')
    .limit(10)
    .get();
    
  return snapshot.docs.map(doc => ({
    role: doc.data().role,
    content: doc.data().content
  }));
}

async function saveConversation(conversationId: string, userId: string, userMessage: string, aiResponse: string) {
  const convId = conversationId || db.collection('conversations').doc().id;
  const convRef = db.collection('conversations').doc(convId);
  
  // Create or update conversation
  await convRef.set({
    userId,
    lastMessage: admin.firestore.FieldValue.serverTimestamp(),
    messageCount: admin.firestore.FieldValue.increment(2)
  }, { merge: true });
  
  // Add messages
  const batch = db.batch();
  
  batch.create(convRef.collection('messages').doc(), {
    role: 'user',
    content: userMessage,
    timestamp: admin.firestore.FieldValue.serverTimestamp()
  });
  
  batch.create(convRef.collection('messages').doc(), {
    role: 'assistant',
    content: aiResponse,
    timestamp: admin.firestore.FieldValue.serverTimestamp()
  });
  
  await batch.commit();
}

async function extractCitations(text: string) {
  // Extract Quranic and Hadith references
  const citations = [];
  
  // Quran pattern: Surah name or number:verse
  const quranPattern = /(?:Surah\s+)?(?:Al-)?(\w+)\s*[:\s]+(\d+)[:\s]*(\d+)?/gi;
  const quranMatches = text.matchAll(quranPattern);
  
  for (const match of quranMatches) {
    citations.push({
      type: 'quran',
      reference: match[0],
      surah: match[1],
      verse: match[2]
    });
  }
  
  // Hadith pattern
  const hadithPattern = /(?:Bukhari|Muslim|Tirmidhi|Abu Dawood)\s*(?:#|:)?\s*(\d+)/gi;
  const hadithMatches = text.matchAll(hadithPattern);
  
  for (const match of hadithMatches) {
    citations.push({
      type: 'hadith',
      reference: match[0],
      collection: match[0].split(/\s*(?:#|:)?\s*/)[0],
      number: match[1]
    });
  }
  
  return citations;
}
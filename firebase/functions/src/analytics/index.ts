import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { BigQuery } from '@google-cloud/bigquery';

const db = admin.firestore();
const bigquery = new BigQuery();

// Log user events
export const logEvent = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { eventName, parameters } = data;
  const userId = context.auth.uid;

  const event = {
    userId,
    eventName,
    parameters,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    platform: parameters.platform || 'unknown',
    appVersion: parameters.appVersion || 'unknown'
  };

  // Store in Firestore for real-time access
  await db.collection('analytics').add(event);

  // Also send to BigQuery for analysis
  await insertIntoBigQuery('events', event);

  return { success: true };
});

// Generate user analytics report
export const getUserAnalytics = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid;
  const { startDate, endDate } = data;

  const analytics = {
    usage: await getUserUsageStats(userId, startDate, endDate),
    progress: await getUserProgress(userId),
    patterns: await getUserPatterns(userId)
  };

  return analytics;
});

// Daily analytics aggregation
export const aggregateDailyAnalytics = functions.pubsub
  .schedule('every 24 hours')
  .timeZone('UTC')
  .onRun(async (context) => {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);

    // Aggregate user statistics
    const users = await db.collection('users').get();
    
    for (const userDoc of users.docs) {
      const userId = userDoc.id;
      const dailyStats = await calculateDailyStats(userId, yesterday);
      
      await db.collection('users').doc(userId)
        .collection('daily_stats')
        .doc(yesterday.toISOString().split('T')[0])
        .set(dailyStats);
    }

    // Aggregate platform statistics
    const platformStats = await calculatePlatformStats(yesterday);
    await db.collection('platform_analytics')
      .doc(yesterday.toISOString().split('T')[0])
      .set(platformStats);

    return null;
  });

// Helper functions
async function insertIntoBigQuery(table: string, data: any) {
  const dataset = bigquery.dataset('duacopilot_analytics');
  const tableRef = dataset.table(table);
  
  await tableRef.insert(data);
}

async function getUserUsageStats(userId: string, startDate: Date, endDate: Date) {
  const events = await db.collection('analytics')
    .where('userId', '==', userId)
    .where('timestamp', '>=', startDate)
    .where('timestamp', '<=', endDate)
    .get();

  const stats = {
    totalEvents: events.size,
    uniqueDays: new Set(events.docs.map(doc => 
      doc.data().timestamp.toDate().toDateString()
    )).size,
    eventTypes: {} as Record<string, number>
  };

  events.docs.forEach(doc => {
    const eventName = doc.data().eventName;
    stats.eventTypes[eventName] = (stats.eventTypes[eventName] || 0) + 1;
  });

  return stats;
}

async function getUserProgress(userId: string) {
  const userDoc = await db.collection('users').doc(userId).get();
  const stats = userDoc.data()?.statistics || {};

  return {
    duasRead: stats.duasRead || 0,
    versesRead: stats.versesRead || 0,
    hadithRead: stats.hadithRead || 0,
    tasbihCount: stats.tasbihCount || 0,
    currentStreak: stats.streak || 0
  };
}

async function getUserPatterns(userId: string) {
  // Analyze user behavior patterns
  const events = await db.collection('analytics')
    .where('userId', '==', userId)
    .orderBy('timestamp', 'desc')
    .limit(1000)
    .get();

  const hourlyActivity = new Array(24).fill(0);
  const dailyActivity = new Array(7).fill(0);

  events.docs.forEach(doc => {
    const timestamp = doc.data().timestamp.toDate();
    hourlyActivity[timestamp.getHours()]++;
    dailyActivity[timestamp.getDay()]++;
  });

  return {
    peakHours: hourlyActivity,
    activeDays: dailyActivity,
    favoriteFeatures: await getFavoriteFeatures(userId)
  };
}

async function getFavoriteFeatures(userId: string) {
  const events = await db.collection('analytics')
    .where('userId', '==', userId)
    .where('eventName', 'in', ['feature_used'])
    .get();

  const features = {} as Record<string, number>;
  
  events.docs.forEach(doc => {
    const feature = doc.data().parameters?.feature;
    if (feature) {
      features[feature] = (features[feature] || 0) + 1;
    }
  });

  return Object.entries(features)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 5)
    .map(([feature]) => feature);
}

async function calculateDailyStats(userId: string, date: Date) {
  // Calculate daily statistics for a user
  return {
    date: date.toISOString().split('T')[0],
    duasRead: 0,
    minutesSpent: 0,
    aiQueries: 0,
    // ... other stats
  };
}

async function calculatePlatformStats(date: Date) {
  // Calculate platform-wide statistics
  return {
    date: date.toISOString().split('T')[0],
    totalUsers: 0,
    activeUsers: 0,
    newUsers: 0,
    totalEvents: 0,
    // ... other stats
  };
}
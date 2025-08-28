import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

const db = admin.firestore();
const messaging = admin.messaging();

// User interface for notifications
interface User {
  id: string;
  timezone?: string;
  location?: {
    lat: number;
    lng: number;
  };
  fcmToken?: string;
  method?: string;
  preferences?: {
    notifications?: boolean;
  };
}

// Schedule prayer notifications
export const schedulePrayerNotifications = functions.pubsub
  .schedule('every 1 hours')
  .timeZone('UTC')
  .onRun(async (context) => {
    const now = new Date();
    const users = await getUsersWithNotificationsEnabled();
    
    for (const user of users) {
      const { timezone, location, fcmToken, method } = user;
      if (!fcmToken || !location) continue;
      
      const prayerTimes = await calculatePrayerTimes(location.lat, location.lng, method || 'MWL', now);
      const nextPrayer = getNextPrayer(prayerTimes, timezone || 'UTC');
      
      if (shouldNotify(nextPrayer, timezone || 'UTC')) {
        await sendPrayerNotification(fcmToken, nextPrayer);
      }
    }
    
    return null;
  });

// Send notification
export const sendNotification = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { userId, title, body, data: notificationData } = data;
  
  // Get user's FCM token
  const userDoc = await db.collection('users').doc(userId).get();
  const fcmToken = userDoc.data()?.fcmToken;
  
  if (!fcmToken) {
    throw new functions.https.HttpsError('failed-precondition', 'User has no FCM token');
  }

  const message: admin.messaging.Message = {
    notification: {
      title,
      body
    },
    data: notificationData || {},
    token: fcmToken,
    android: {
      notification: {
        icon: 'ic_notification',
        color: '#0F5132'
      }
    },
    apns: {
      payload: {
        aps: {
          badge: 1,
          sound: 'default'
        }
      }
    }
  };

  try {
    const response = await messaging.send(message);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
});

// Update FCM token
export const updateFcmToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { token } = data;
  const userId = context.auth.uid;

  await db.collection('users').doc(userId).update({
    fcmToken: token,
    fcmTokenUpdatedAt: admin.firestore.FieldValue.serverTimestamp()
  });

  return { success: true };
});

// Helper functions
async function getUsersWithNotificationsEnabled(): Promise<User[]> {
  const snapshot = await db.collection('users')
    .where('preferences.notifications', '==', true)
    .where('fcmToken', '!=', null)
    .get();
    
  return snapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data()
  } as User));
}

async function calculatePrayerTimes(lat: number, lng: number, method: string, date: Date) {
  // Simplified prayer time calculation - in production, use a proper Islamic library
  // This is just a placeholder implementation
  return {
    fajr: '05:30',
    dhuhr: '12:30',
    asr: '15:45',
    maghrib: '18:00',
    isha: '19:30'
  };
}

async function sendPrayerNotification(token: string, prayer: any) {
  const message: admin.messaging.Message = {
    notification: {
      title: `${prayer.name} Prayer Time`,
      body: `It's time for ${prayer.name} prayer (${prayer.time})`
    },
    data: {
      type: 'prayer_time',
      prayer: prayer.name,
      time: prayer.time
    },
    token,
    android: {
      priority: 'high',
      notification: {
        sound: 'adhan.mp3',
        channelId: 'prayer_times'
      }
    }
  };

  await messaging.send(message);
}

function getNextPrayer(prayerTimes: any, timezone: string) {
  // Implementation to determine next prayer based on current time
  // Returns prayer name and time
  return {
    name: 'Dhuhr',
    time: '12:30'
  };
}

function shouldNotify(prayer: any, timezone: string) {
  // Check if it's time to notify (e.g., 10 minutes before prayer)
  return true; // Simplified
}
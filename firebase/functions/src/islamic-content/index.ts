import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();

// Get duas based on filters
export const getDuas = functions.https.onCall(async (data, context) => {
  const { category, emotion, context: duaContext, language = 'en', limit = 20 } = data;
  
  let query = db.collection('duas').limit(limit);
  
  if (category) {
    query = query.where('categories', 'array-contains', category);
  }
  
  if (emotion) {
    query = query.where('emotions', 'array-contains', emotion);
  }
  
  if (duaContext) {
    query = query.where('contexts', 'array-contains', duaContext);
  }
  
  const snapshot = await query.get();
  const duas = snapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data(),
    translation: doc.data().translations?.[language] || doc.data().translations?.en
  }));
  
  return { duas };
});

// Search Quran verses
export const searchQuran = functions.https.onCall(async (data, context) => {
  const { query, language = 'en', limit = 20 } = data;
  
  // Implement full-text search using Algolia or ElasticSearch
  // For now, simple Firestore query
  const snapshot = await db.collection('quran')
    .where('topics', 'array-contains', query.toLowerCase())
    .limit(limit)
    .get();
    
  const verses = snapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data(),
    translation: doc.data().translations?.[language] || doc.data().translations?.en
  }));
  
  return { verses };
});

// Get prayer times
export const getPrayerTimes = functions.https.onCall(async (data, context) => {
  const { latitude, longitude, method = 'MWL', date = new Date() } = data;
  
  // Integrate with Aladhan API or calculate internally
  const prayerTimes = await calculatePrayerTimes(latitude, longitude, method, date);
  
  return { prayerTimes };
});

// Get Qibla direction
export const getQiblaDirection = functions.https.onCall(async (data, context) => {
  const { latitude, longitude } = data;
  
  // Kaaba coordinates
  const kaabaLat = 21.4225;
  const kaabaLng = 39.8262;
  
  // Calculate Qibla direction
  const qiblaDirection = calculateQiblaDirection(latitude, longitude, kaabaLat, kaabaLng);
  
  return { 
    qiblaDirection,
    compass: qiblaDirection,
    accuracy: 'high'
  };
});

// Helper functions
async function calculatePrayerTimes(lat: number, lng: number, method: string, date: Date) {
  // Implement prayer time calculation algorithm
  // Or use external API like Aladhan
  return {
    fajr: '05:30',
    sunrise: '06:45',
    dhuhr: '12:30',
    asr: '15:45',
    maghrib: '18:30',
    isha: '20:00'
  };
}

function calculateQiblaDirection(lat1: number, lng1: number, lat2: number, lng2: number) {
  const φ1 = lat1 * Math.PI / 180;
  const φ2 = lat2 * Math.PI / 180;
  const Δλ = (lng2 - lng1) * Math.PI / 180;
  
  const x = Math.sin(Δλ) * Math.cos(φ2);
  const y = Math.cos(φ1) * Math.sin(φ2) - Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ);
  
  const θ = Math.atan2(x, y);
  
  return (θ * 180 / Math.PI + 360) % 360;
}
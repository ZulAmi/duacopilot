import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const db = admin.firestore();
const auth = admin.auth();

// Create user profile on signup
export const onUserCreated = functions.auth.user().onCreate(async (user) => {
  const { uid, email, displayName, photoURL } = user;
  
  try {
    // Create user profile in Firestore
    await db.collection('users').doc(uid).set({
      uid,
      email,
      displayName: displayName || '',
      photoURL: photoURL || '',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLogin: admin.firestore.FieldValue.serverTimestamp(),
      preferences: {
        language: 'en',
        notifications: true,
        theme: 'light',
        culturalRegion: 'general',
        prayerMethod: 'MWL', // Muslim World League
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
    });

    // Send welcome email
    await sendWelcomeEmail(email!, displayName || 'User');
    
    return { success: true };
  } catch (error) {
    console.error('Error creating user profile:', error);
    throw new functions.https.HttpsError('internal', 'Failed to create user profile');
  }
});

// Update last login
export const updateLastLogin = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const uid = context.auth.uid;
  
  await db.collection('users').doc(uid).update({
    lastLogin: admin.firestore.FieldValue.serverTimestamp()
  });

  return { success: true };
});

// Custom claims for premium users
export const setCustomClaims = functions.https.onCall(async (data, context) => {
  // Only allow admins to set custom claims
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError('permission-denied', 'Only admins can set custom claims');
  }

  const { uid, claims } = data;
  
  await auth.setCustomUserClaims(uid, claims);
  
  return { success: true };
});

async function sendWelcomeEmail(email: string, name: string) {
  // Implement email sending logic using SendGrid/Firebase Extensions
  console.log(`Sending welcome email to ${email}`);
}
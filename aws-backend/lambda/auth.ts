// Authentication Lambda Functions
import jwt from 'jsonwebtoken';
import { DatabaseService, HttpsError, lambdaWrapper, serverTimestamp } from './shared/lambda-adapter';

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
    const token = jwt.sign(
      { 
        uid: userId, 
        email,
        admin: false,
        premium: false 
      },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    );

    return { success: true, userId, token };
  } catch (error) {
    console.error('Error creating user profile:', error);
    throw new HttpsError('internal', 'Failed to create user profile');
  }
});

export const updateLastLogin = lambdaWrapper(async (data: any, context: any) => {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid;
  
  try {
    // Update last login timestamp
    await DatabaseService.putDocument(process.env.USER_TABLE!, {
      userId,
      lastLogin: serverTimestamp(),
    });

    return { success: true };
  } catch (error) {
    console.error('Error updating last login:', error);
    throw new HttpsError('internal', 'Failed to update last login');
  }
});

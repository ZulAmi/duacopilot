import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

// Initialize Firebase Admin
admin.initializeApp();

// Export all function modules
export * from './ai-services';
export * from './analytics';
export * from './auth';
export * from './islamic-content';
export * from './notifications';
export * from './user-management';

// Health check endpoint
export const healthCheck = functions.https.onRequest((req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'DuaCopilot Backend API',
    version: '1.0.0'
  });
});
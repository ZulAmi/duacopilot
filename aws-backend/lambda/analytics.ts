// Analytics Lambda Functions
import { DatabaseService, HttpsError, lambdaWrapper } from './shared/lambda-adapter';

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
    platform: parameters?.platform || 'unknown',
    appVersion: parameters?.appVersion || 'unknown',
    sessionId: parameters?.sessionId || '',
    createdAt: new Date().toISOString(),
  };

  try {
    await DatabaseService.putDocument(process.env.ANALYTICS_TABLE!, event);
    return { success: true, eventId: event.eventId };
  } catch (error) {
    console.error('Error logging event:', error);
    throw new HttpsError('internal', 'Failed to log event');
  }
});

export const getUserAnalytics = lambdaWrapper(async (data: any, context: any) => {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid;
  const { startDate, endDate, limit = 100 } = data;

  try {
    // Query user analytics from DynamoDB
    const analytics = await DatabaseService.queryDocuments(
      process.env.ANALYTICS_TABLE!,
      {
        IndexName: 'UserTimeIndex',
        KeyConditionExpression: 'userId = :uid',
        ExpressionAttributeValues: {
          ':uid': userId,
        },
        ScanIndexForward: false,
        Limit: limit,
      }
    );

    return { analytics };
  } catch (error) {
    console.error('Error getting user analytics:', error);
    throw new HttpsError('internal', 'Failed to get user analytics');
  }
});

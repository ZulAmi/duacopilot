// Notifications Lambda Functions
import { PublishCommand, SNSClient } from '@aws-sdk/client-sns';
import { getPrayerTimes } from './shared/helpers';
import { DatabaseService, HttpsError, lambdaWrapper } from './shared/lambda-adapter';

const snsClient = new SNSClient({ region: process.env.AWS_REGION });

export const sendNotification = lambdaWrapper(async (data: any, context: any) => {
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { title, body, type, targetUserId } = data;
  const userId = context.auth.uid;

  try {
    // Send notification via SNS
    const message = {
      title,
      body,
      type: type || 'general',
      fromUserId: userId,
      targetUserId,
      timestamp: Date.now(),
    };

    const command = new PublishCommand({
      TopicArn: process.env.NOTIFICATION_TOPIC_ARN!,
      Message: JSON.stringify(message),
      Subject: title,
    });

    await snsClient.send(command);

    return { success: true, messageId: 'sent' };
  } catch (error) {
    console.error('Error sending notification:', error);
    throw new HttpsError('internal', 'Failed to send notification');
  }
});

export const schedulePrayerNotifications = lambdaWrapper(async (data: any, context: any) => {
  // This function runs on a schedule to notify users about prayer times
  try {
    // Get all users who have prayer notifications enabled
    const users = await DatabaseService.queryDocuments(
      process.env.USER_TABLE!,
      {
        FilterExpression: 'preferences.notifications = :enabled',
        ExpressionAttributeValues: {
          ':enabled': true,
        },
      }
    );

    const notifications: any[] = [];
    const currentTime = new Date();

    for (const user of users) {
      if (user.location?.latitude && user.location?.longitude) {
        // Get prayer times for user location
        const prayerTimes = await getPrayerTimes(
          user.location.latitude,
          user.location.longitude
        );

        // Check which prayers are due soon and schedule notifications
        // Implementation would check current time against prayer times
        // and send notifications accordingly
        
        notifications.push({
          userId: user.userId,
          prayerTimes,
          scheduled: true,
        });
      }
    }

    return { 
      success: true, 
      processedUsers: users.length, 
      scheduledNotifications: notifications.length 
    };
  } catch (error) {
    console.error('Error scheduling prayer notifications:', error);
    throw new HttpsError('internal', 'Failed to schedule prayer notifications');
  }
});

export const healthCheck = lambdaWrapper(async (data: any, context: any) => {
  return {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    service: 'duacopilot-backend',
  };
});

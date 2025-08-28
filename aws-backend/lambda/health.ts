// Health Check Lambda Function
import { lambdaWrapper } from './shared/lambda-adapter';

export const healthCheck = lambdaWrapper(async (data: any, context: any) => {
  return {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    service: 'duacopilot-backend',
    environment: process.env.STAGE || 'development',
    region: process.env.AWS_REGION || 'us-east-1',
  };
});

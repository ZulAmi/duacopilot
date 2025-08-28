// AWS Lambda Adapter for Firebase Functions
// Converts Firebase HTTP callable functions to AWS Lambda

import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, PutCommand, QueryCommand } from '@aws-sdk/lib-dynamodb';
import { APIGatewayProxyEvent, APIGatewayProxyResult, Context } from 'aws-lambda';
import jwt from 'jsonwebtoken';

// AWS clients
const dynamoClient = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(dynamoClient);

// JWT secret from environment
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Auth context interface (mimics Firebase)
interface AuthContext {
  auth?: {
    uid: string;
    token: {
      admin?: boolean;
      premium?: boolean;
    };
  };
}

// Lambda wrapper for Firebase functions
export const lambdaWrapper = (firebaseFunction: Function) => {
  return async (event: APIGatewayProxyEvent, context: Context): Promise<APIGatewayProxyResult> => {
    try {
      // Parse request body
      const data = event.body ? JSON.parse(event.body) : {};
      
      // Create auth context from JWT token
      const authContext = await createAuthContext(event);
      
      // Call Firebase function with adapted parameters
      const result = await firebaseFunction(data, authContext);
      
      return {
        statusCode: 200,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type,Authorization',
          'Access-Control-Allow-Methods': 'GET,HEAD,OPTIONS,POST,PUT',
        },
        body: JSON.stringify(result),
      };
    } catch (error) {
      console.error('Lambda error:', error);
      
      return {
        statusCode: 500,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: JSON.stringify({
          error: error instanceof Error ? error.message : 'Internal server error',
        }),
      };
    }
  };
};

// Create auth context from JWT token
async function createAuthContext(event: APIGatewayProxyEvent): Promise<AuthContext> {
  const authHeader = event.headers.Authorization || event.headers.authorization;
  
  if (!authHeader) {
    return {};
  }
  
  try {
    const token = authHeader.replace('Bearer ', '');
    const decoded = jwt.verify(token, JWT_SECRET) as any;
    
    return {
      auth: {
        uid: decoded.uid,
        token: {
          admin: decoded.admin || false,
          premium: decoded.premium || false,
        },
      },
    };
  } catch (error) {
    console.error('JWT verification error:', error);
    return {};
  }
}

// DynamoDB helper functions (replaces Firestore)
export class DatabaseService {
  static async getDocument(tableName: string, key: any) {
    const command = new GetCommand({
      TableName: tableName,
      Key: key,
    });
    
    const response = await docClient.send(command);
    return response.Item;
  }
  
  static async putDocument(tableName: string, item: any) {
    const command = new PutCommand({
      TableName: tableName,
      Item: {
        ...item,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      },
    });
    
    await docClient.send(command);
  }
  
  static async queryDocuments(tableName: string, keyCondition: any) {
    const command = new QueryCommand({
      TableName: tableName,
      ...keyCondition,
    });
    
    const response = await docClient.send(command);
    return response.Items || [];
  }
}

// Error handling (mimics Firebase functions errors)
export class HttpsError extends Error {
  constructor(public code: string, message: string) {
    super(message);
    this.name = 'HttpsError';
  }
}

// Timestamp helper
export const serverTimestamp = () => new Date().toISOString();

// Example: Migrate Firebase AI Chat function
export const aiChatLambda = lambdaWrapper(async (data: any, context: AuthContext) => {
  // Check authentication
  if (!context.auth) {
    throw new HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { message, conversationId, language = 'en' } = data;
  const userId = context.auth.uid;
  
  // Get user preferences from DynamoDB
  const userDoc = await DatabaseService.getDocument(
    process.env.USER_TABLE!,
    { userId }
  );
  
  // Your existing AI chat logic here...
  // This would be the same as your Firebase function
  
  return {
    response: 'AI response here',
    conversationId: conversationId || 'new-conversation-id',
  };
});

// Example: Migrate Firebase Auth function
export const createUserLambda = lambdaWrapper(async (data: any, context: AuthContext) => {
  const { email, password, displayName } = data;
  
  // Create user in DynamoDB
  const userId = `user_${Date.now()}`;
  const userProfile = {
    userId,
    email,
    displayName: displayName || '',
    createdAt: serverTimestamp(),
    preferences: {
      language: 'en',
      notifications: true,
      theme: 'light',
    },
    subscription: {
      plan: 'free',
      status: 'active',
    },
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
    JWT_SECRET,
    { expiresIn: '7d' }
  );
  
  return {
    success: true,
    userId,
    token,
  };
});

// Example: Health check
export const healthCheckLambda = async (
  event: APIGatewayProxyEvent,
  context: Context
): Promise<APIGatewayProxyResult> => {
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
    body: JSON.stringify({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      service: 'DuaCopilot AWS Backend',
      version: '1.0.0',
      environment: process.env.STAGE,
    }),
  };
};

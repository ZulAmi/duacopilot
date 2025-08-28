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

// Error classes (mimics Firebase functions)
export class HttpsError extends Error {
  constructor(public code: string, message: string, public details?: any) {
    super(message);
    this.name = 'HttpsError';
  }
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
      
      if (error instanceof HttpsError) {
        return {
          statusCode: 400,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
          },
          body: JSON.stringify({
            error: {
              code: error.code,
              message: error.message,
              details: error.details,
            },
          }),
        };
      }
      
      return {
        statusCode: 500,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: JSON.stringify({
          error: {
            code: 'internal',
            message: 'Internal server error',
          },
        }),
      };
    }
  };
};

// Create auth context from JWT token
async function createAuthContext(event: APIGatewayProxyEvent): Promise<AuthContext> {
  const authHeader = event.headers.Authorization || event.headers.authorization;
  
  if (!authHeader?.startsWith('Bearer ')) {
    return {};
  }
  
  try {
    const token = authHeader.slice(7);
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
    console.error('JWT verification failed:', error);
    return {};
  }
}

// Database service (mimics Firebase Firestore)
export const DatabaseService = {
  async getDocument(tableName: string, key: any) {
    try {
      const command = new GetCommand({
        TableName: tableName,
        Key: key,
      });
      const result = await docClient.send(command);
      return result.Item;
    } catch (error) {
      console.error('DynamoDB get error:', error);
      return null;
    }
  },
  
  async putDocument(tableName: string, item: any) {
    try {
      const command = new PutCommand({
        TableName: tableName,
        Item: item,
      });
      await docClient.send(command);
      return true;
    } catch (error) {
      console.error('DynamoDB put error:', error);
      return false;
    }
  },
  
  async queryDocuments(tableName: string, params: any) {
    try {
      const command = new QueryCommand({
        TableName: tableName,
        ...params,
      });
      const result = await docClient.send(command);
      return result.Items || [];
    } catch (error) {
      console.error('DynamoDB query error:', error);
      return [];
    }
  },
};

// Server timestamp (mimics Firebase)
export const serverTimestamp = () => Date.now();

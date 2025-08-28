#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import 'source-map-support/register';
import { DuaCopilotBackendStack } from '../lib/duacopilot-backend-stack';

const app = new cdk.App();

new DuaCopilotBackendStack(app, 'DuaCopilotBackendStack', {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION || 'us-east-1',
  },
  
  // Stack configuration
  stackName: 'DuaCopilotBackend',
  description: 'DuaCopilot Islamic AI Assistant Backend Infrastructure',
  
  // Environment-specific settings
  stage: process.env.STAGE || 'dev',
  
  // Resource naming
  prefix: 'duacopilot',
  
  // External service configurations
  openaiApiKey: process.env.OPENAI_API_KEY,
  sendgridApiKey: process.env.SENDGRID_API_KEY,
});

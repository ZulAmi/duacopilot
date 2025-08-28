# DuaCopilot AWS Backend Deployment Guide

## Prerequisites Installation

### 1. Install AWS CLI v2

Download and install: https://awscli.amazonaws.com/AWSCLIV2.msi
After installation, restart your PowerShell/Command Prompt.

### 2. Install AWS CDK CLI

```powershell
npm install -g aws-cdk
```

### 3. Configure AWS Credentials

```powershell
aws configure
```

You'll need:

- AWS Access Key ID
- AWS Secret Access Key
- Default region (recommend: us-east-1)
- Output format (recommend: json)

## Environment Setup

### 1. Create .env file

Copy `.env.example` to `.env` and fill in your values:

```bash
# Required API Keys
OPENAI_API_KEY=sk-your-openai-key-here
SENDGRID_API_KEY=SG.your-sendgrid-key-here
JWT_SECRET=your-256-bit-secret-key-here

# AWS Configuration
AWS_REGION=us-east-1
STAGE=production
```

### 2. Bootstrap CDK (First time only)

```powershell
cdk bootstrap aws://ACCOUNT-NUMBER/us-east-1
```

## Deployment Commands

### Option 1: CDK Deployment (Recommended)

```powershell
# Build the project
npm run build

# Deploy infrastructure
npm run migrate-cdk
```

### Option 2: Serverless Framework

```powershell
# Deploy with Serverless
npm run migrate-lambda
```

## Post-Deployment

### 1. Test the API

The deployment will output an API Gateway URL. Test with:

```bash
curl -X POST YOUR_API_URL/health-check
```

### 2. Configure Domain (Optional)

Add a custom domain in AWS Console > API Gateway > Custom Domain Names

### 3. Monitor Logs

View logs in AWS Console > CloudWatch > Log Groups

## Troubleshooting

### Common Issues:

1. **AWS CLI not found**: Install AWS CLI v2 and restart terminal
2. **Permission denied**: Check AWS credentials and IAM permissions
3. **CDK bootstrap needed**: Run `cdk bootstrap` first
4. **Environment variables**: Ensure .env file has correct values

### Required AWS Permissions:

Your AWS user needs these services:

- CloudFormation (full access)
- Lambda (full access)
- DynamoDB (full access)
- API Gateway (full access)
- S3 (for CDK assets)
- CloudWatch Logs
- SNS

## Architecture Overview

This deployment creates:

- 11 Lambda functions for different services
- 3 DynamoDB tables (users, conversations, analytics)
- API Gateway with CORS enabled
- S3 bucket for file storage
- SNS topic for notifications
- CloudWatch scheduled events for prayer notifications

Total estimated cost: $5-20/month for moderate usage.

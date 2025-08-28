# AWS Configuration Guide for DuaCopilot

## Step 1: Get AWS Credentials

1. Go to AWS Console: https://console.aws.amazon.com/
2. Navigate to: IAM > Users > Your User > Security credentials
3. Click "Create access key"
4. Choose "Local code" and create key
5. Download credentials (Access Key ID + Secret Access Key)

## Step 2: Configure AWS CLI

After installing AWS CLI, run:

```bash
aws configure
```

Enter your credentials:

- AWS Access Key ID: [Your Access Key]
- AWS Secret Access Key: [Your Secret Key]
- Default region name: us-east-1
- Default output format: json

## Step 3: Verify Configuration

```bash
aws sts get-caller-identity
```

This should return your AWS account information.

## Required Permissions

Your AWS user needs these permissions:

- S3: CreateBucket, PutObject, DeleteObject, ListBucket
- CloudFront: CreateDistribution, CreateInvalidation
- IAM: Basic read permissions

## Security Best Practice

Create a specific user for deployment with minimal required permissions.

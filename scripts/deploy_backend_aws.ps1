#!/usr/bin/env powershell
# DuaCopilot Backend AWS Deployment Script
# Complete migration from Firebase to AWS

param(
    [ValidateSet("serverless", "cdk", "container")]
    [string]$DeploymentType = "serverless",
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment = "dev",
    [string]$AwsRegion = "us-east-1"
)

Write-Host "🚀 DuaCopilot Backend AWS Deployment" -ForegroundColor Cyan
Write-Host "Deployment Type: $DeploymentType" -ForegroundColor Yellow
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "Region: $AwsRegion" -ForegroundColor Yellow
Write-Host ""

# Check prerequisites
Write-Host "🔍 Checking prerequisites..." -ForegroundColor Blue

# Check AWS CLI
try {
    $awsIdentity = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" sts get-caller-identity --output json | ConvertFrom-Json
    Write-Host "✅ AWS CLI configured for account: $($awsIdentity.Account)" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI not configured. Please run 'aws configure' first." -ForegroundColor Red
    exit 1
}

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js 18+" -ForegroundColor Red
    exit 1
}

# Create backend directory structure
Write-Host "📁 Creating backend structure..." -ForegroundColor Blue
$backendDir = "aws-backend"
if (-not (Test-Path $backendDir)) {
    New-Item -ItemType Directory -Path $backendDir
}

# Copy Firebase Functions code
Write-Host "📋 Copying Firebase Functions..." -ForegroundColor Blue
if (Test-Path "firebase/functions/src") {
    Copy-Item -Path "firebase/functions/src/*" -Destination "$backendDir/src" -Recurse -Force
    Write-Host "✅ Firebase Functions copied" -ForegroundColor Green
} else {
    Write-Host "⚠️  Firebase Functions not found, creating sample structure" -ForegroundColor Yellow
}

# Set environment variables
Write-Host "🔧 Setting environment variables..." -ForegroundColor Blue
$env:AWS_REGION = $AwsRegion
$env:STAGE = $Environment

# Deploy based on type
switch ($DeploymentType) {
    "serverless" {
        Write-Host "🔄 Deploying with Serverless Framework..." -ForegroundColor Blue
        
        # Install dependencies
        Set-Location $backendDir
        npm install
        
        # Install Serverless globally if not present
        try {
            serverless --version
        } catch {
            Write-Host "📥 Installing Serverless Framework..." -ForegroundColor Blue
            npm install -g serverless
        }
        
        # Configure AWS credentials for Serverless
        serverless config credentials --provider aws --key $env:AWS_ACCESS_KEY_ID --secret $env:AWS_SECRET_ACCESS_KEY
        
        # Deploy
        Write-Host "🚀 Deploying serverless backend..." -ForegroundColor Blue
        serverless deploy --stage $Environment --region $AwsRegion
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Serverless deployment successful!" -ForegroundColor Green
        } else {
            Write-Host "❌ Serverless deployment failed" -ForegroundColor Red
            exit 1
        }
    }
    
    "cdk" {
        Write-Host "🔄 Deploying with AWS CDK..." -ForegroundColor Blue
        
        Set-Location $backendDir
        npm install
        
        # Install CDK globally if not present
        try {
            cdk --version
        } catch {
            Write-Host "📥 Installing AWS CDK..." -ForegroundColor Blue
            npm install -g aws-cdk
        }
        
        # Bootstrap CDK
        Write-Host "🔄 Bootstrapping CDK..." -ForegroundColor Blue
        cdk bootstrap --region $AwsRegion
        
        # Build and deploy
        Write-Host "🔨 Building CDK app..." -ForegroundColor Blue
        npm run build
        
        Write-Host "🚀 Deploying CDK stack..." -ForegroundColor Blue
        cdk deploy --region $AwsRegion --require-approval never
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ CDK deployment successful!" -ForegroundColor Green
        } else {
            Write-Host "❌ CDK deployment failed" -ForegroundColor Red
            exit 1
        }
    }
    
    "container" {
        Write-Host "🔄 Deploying with ECS Fargate..." -ForegroundColor Blue
        
        # Build Docker image
        Write-Host "🐳 Building Docker image..." -ForegroundColor Blue
        Set-Location $backendDir
        docker build -t duacopilot-backend:$Environment .
        
        # Create ECR repository
        Write-Host "📦 Creating ECR repository..." -ForegroundColor Blue
        & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" ecr create-repository --repository-name duacopilot-backend --region $AwsRegion
        
        # Get ECR login
        $ecrLogin = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" ecr get-login-password --region $AwsRegion
        $accountId = $awsIdentity.Account
        $ecrUri = "$accountId.dkr.ecr.$AwsRegion.amazonaws.com"
        
        # Login to ECR
        Write-Host "🔐 Logging in to ECR..." -ForegroundColor Blue
        echo $ecrLogin | docker login --username AWS --password-stdin $ecrUri
        
        # Tag and push image
        Write-Host "⬆️  Pushing Docker image to ECR..." -ForegroundColor Blue
        docker tag duacopilot-backend:$Environment $ecrUri/duacopilot-backend:$Environment
        docker push $ecrUri/duacopilot-backend:$Environment
        
        Write-Host "✅ Container deployment prepared!" -ForegroundColor Green
        Write-Host "Next: Create ECS cluster and service manually or use CDK/CloudFormation" -ForegroundColor Yellow
    }
}

# Get API endpoint
Write-Host ""
Write-Host "🎉 Backend Deployment Complete!" -ForegroundColor Green
Write-Host "Environment: $Environment" -ForegroundColor Cyan
Write-Host "Region: $AwsRegion" -ForegroundColor Cyan

if ($DeploymentType -eq "serverless") {
    Write-Host "API Endpoint: Check Serverless output above" -ForegroundColor Yellow
} elseif ($DeploymentType -eq "cdk") {
    Write-Host "API Endpoint: Check CDK output above" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Update Flutter app API endpoints" -ForegroundColor White
Write-Host "2. Configure environment variables" -ForegroundColor White
Write-Host "3. Set up monitoring and logging" -ForegroundColor White
Write-Host "4. Configure custom domain (optional)" -ForegroundColor White
Write-Host ""
Write-Host "🔗 AWS Management Console: https://console.aws.amazon.com/" -ForegroundColor Blue

Set-Location ..

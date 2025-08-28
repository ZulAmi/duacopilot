#!/usr/bin/env powershell
# DuaCopilot AWS Deployment Script
# Run this script to deploy the backend to AWS

Write-Host "🚀 DuaCopilot AWS Backend Deployment" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

# Check AWS CLI
try {
    $awsVersion = aws --version 2>&1
    Write-Host "✅ AWS CLI found: $awsVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI not found. Please install AWS CLI v2:" -ForegroundColor Red
    Write-Host "   https://awscli.amazonaws.com/AWSCLIV2.msi" -ForegroundColor Yellow
    exit 1
}

# Check AWS credentials
try {
    $awsId = aws sts get-caller-identity --query 'Account' --output text 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ AWS credentials configured for account: $awsId" -ForegroundColor Green
    } else {
        Write-Host "❌ AWS credentials not configured. Run: aws configure" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ AWS credentials not configured. Run: aws configure" -ForegroundColor Red
    exit 1
}

# Check CDK
try {
    $cdkVersion = cdk --version 2>&1
    Write-Host "✅ AWS CDK found: $cdkVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CDK not found. Installing..." -ForegroundColor Yellow
    npm install -g aws-cdk
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install AWS CDK" -ForegroundColor Red
        exit 1
    }
}

# Check environment file
if (Test-Path ".env") {
    Write-Host "✅ Environment file found" -ForegroundColor Green
    
    # Check for required variables
    $envContent = Get-Content ".env" -Raw
    if ($envContent -match "OPENAI_API_KEY=sk-") {
        Write-Host "✅ OpenAI API key configured" -ForegroundColor Green
    } else {
        Write-Host "⚠️  OpenAI API key not configured in .env" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ .env file not found. Please create one from .env.example" -ForegroundColor Red
    exit 1
}

# Build project
Write-Host "`n🔨 Building TypeScript..." -ForegroundColor Yellow
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Build successful" -ForegroundColor Green

# CDK Bootstrap (if needed)
Write-Host "`n🥾 Checking CDK bootstrap..." -ForegroundColor Yellow
$bootstrapCheck = cdk list 2>&1
if ($bootstrapCheck -like "*is not bootstrapped*") {
    Write-Host "⚠️  CDK not bootstrapped. Bootstrapping..." -ForegroundColor Yellow
    cdk bootstrap
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ CDK bootstrap failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ CDK bootstrap successful" -ForegroundColor Green
} else {
    Write-Host "✅ CDK already bootstrapped" -ForegroundColor Green
}

# Deploy with CDK
Write-Host "`n🚀 Deploying to AWS..." -ForegroundColor Yellow
Write-Host "This may take 5-10 minutes for the first deployment..." -ForegroundColor Cyan

cdk deploy --require-approval never
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 Deployment successful!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Your DuaCopilot backend is now running on AWS!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Note the API Gateway URL from the output above" -ForegroundColor White
Write-Host "2. Test the health check endpoint" -ForegroundColor White
Write-Host "3. Update your Flutter app to use the new API URL" -ForegroundColor White
Write-Host "`nMonitoring:" -ForegroundColor Yellow
Write-Host "- View logs: AWS Console > CloudWatch > Log Groups" -ForegroundColor White
Write-Host "- Monitor usage: AWS Console > Lambda > Functions" -ForegroundColor White

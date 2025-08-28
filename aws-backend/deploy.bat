@echo off
REM DuaCopilot AWS Deployment Script (Batch version)
echo.
echo 🚀 DuaCopilot AWS Backend Deployment
echo =====================================

echo 📋 Checking prerequisites...

REM Check if AWS CLI is available
aws --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ AWS CLI not found. 
    echo Please install AWS CLI v2 from: https://awscli.amazonaws.com/AWSCLIV2.msi
    echo Then restart your command prompt and run this script again.
    pause
    exit /b 1
) else (
    aws --version
    echo ✅ AWS CLI found
)

REM Check AWS credentials
aws sts get-caller-identity >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ AWS credentials not configured
    echo Please run: aws configure
    pause
    exit /b 1
) else (
    echo ✅ AWS credentials configured
)

REM Install/check CDK
cdk --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ AWS CDK not found. Installing...
    npm install -g aws-cdk
    if %errorlevel% neq 0 (
        echo ❌ Failed to install AWS CDK
        pause
        exit /b 1
    )
) else (
    echo ✅ AWS CDK found
)

REM Build project  
echo.
echo 🔨 Building TypeScript...
npm run build
if %errorlevel% neq 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)
echo ✅ Build successful

REM Bootstrap CDK if needed
echo.
echo 🥾 Bootstrapping CDK...
cdk bootstrap
if %errorlevel% neq 0 (
    echo ⚠️ CDK bootstrap may have failed, continuing...
)

REM Deploy
echo.
echo 🚀 Deploying to AWS...
echo This may take 5-10 minutes...
cdk deploy --require-approval never

if %errorlevel% neq 0 (
    echo ❌ Deployment failed
    pause
    exit /b 1
)

echo.
echo 🎉 Deployment successful!
echo Your DuaCopilot backend is now running on AWS!
echo.
echo Check the output above for your API Gateway URL
pause

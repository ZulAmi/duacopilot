@echo off
REM AWS Deployment Script for DuaCopilot (Windows)

echo ================================================================
echo  DuaCopilot AWS Deployment
echo ================================================================
echo.

REM Configuration - UPDATE THESE VALUES
set AWS_REGION=us-east-1
set S3_BUCKET=%1
set CLOUDFRONT_ID=%2

REM Check if bucket name provided
if "%S3_BUCKET%"=="" (
    echo ❌ Please provide S3 bucket name as first argument
    echo Usage: deploy_aws.bat your-bucket-name [cloudfront-id]
    echo.
    echo Example: deploy_aws.bat duacopilot-web-1234 E1234567890123
    pause
    exit /b 1
)

echo Using S3 Bucket: %S3_BUCKET%
if not "%CLOUDFRONT_ID%"=="" (
    echo Using CloudFront Distribution: %CLOUDFRONT_ID%
)
echo.

REM Check AWS CLI - try multiple locations
set AWS_CMD=aws
where aws >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo AWS CLI not in PATH, trying default installation location...
    if exist "C:\Program Files\Amazon\AWSCLIV2\aws.exe" (
        set AWS_CMD="C:\Program Files\Amazon\AWSCLIV2\aws.exe"
        echo Found AWS CLI at default location
    ) else (
        echo ❌ AWS CLI not found. Please install AWS CLI first.
        echo Download from: https://awscli.amazonaws.com/AWSCLIV2.msi
        echo Or run: .\scripts\setup_aws_cli.ps1
        pause
        exit /b 1
    )
)

REM Check AWS credentials
%AWS_CMD% sts get-caller-identity >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ AWS not configured. Please run: .\scripts\setup_aws_cli.ps1
    pause
    exit /b 1
)

echo Building Flutter Web App...
flutter clean
flutter pub get
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Build failed! Please fix the errors above.
    pause
    exit /b 1
)

echo.
echo ✅ Build completed successfully!
echo.

echo Deploying to AWS S3 (%S3_BUCKET%)...
%AWS_CMD% s3 sync build\web s3://%S3_BUCKET% --delete --region %AWS_REGION%

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ S3 deployment failed! Please check your AWS configuration.
    pause
    exit /b 1
)

echo ✅ S3 deployment completed!

REM Invalidate CloudFront if distribution ID is set
if not "%CLOUDFRONT_ID%"=="" (
    echo Invalidating CloudFront cache...
    %AWS_CMD% cloudfront create-invalidation --distribution-id %CLOUDFRONT_ID% --paths "/*"
    if %ERRORLEVEL% EQU 0 (
        echo ✅ CloudFront cache invalidated!
    ) else (
        echo ⚠️ CloudFront invalidation failed (non-critical)
    )
)

echo.
echo ================================================================
echo  ✅ AWS deployment completed successfully!
echo  🌐 Live at: https://%S3_BUCKET%.s3-website-%AWS_REGION%.amazonaws.com
echo ================================================================
echo.
pause

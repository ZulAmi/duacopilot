#!/bin/bash
# AWS Deployment Script for DuaCopilot

echo "================================================================"
echo " DuaCopilot AWS Deployment"  
echo "================================================================"
echo

# Configuration
AWS_REGION="us-east-1"
S3_BUCKET="duacopilot-web-${ENVIRONMENT:-dev}"
CLOUDFRONT_ID=""  # Set your CloudFront distribution ID

echo "Building Flutter Web App..."
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

if [ $? -ne 0 ]; then
    echo "❌ Build failed! Please fix the errors above."
    exit 1
fi

echo "✅ Build completed successfully!"
echo

echo "Deploying to AWS S3 (${S3_BUCKET})..."
aws s3 sync build/web s3://${S3_BUCKET} --delete --region ${AWS_REGION}

if [ $? -ne 0 ]; then
    echo "❌ S3 deployment failed! Please check your AWS configuration."
    exit 1
fi

echo "✅ S3 deployment completed!"

# Invalidate CloudFront if distribution ID is set
if [ ! -z "${CLOUDFRONT_ID}" ]; then
    echo "Invalidating CloudFront cache..."
    aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_ID} --paths "/*"
    echo "✅ CloudFront cache invalidated!"
fi

echo
echo "================================================================"
echo " ✅ AWS deployment completed successfully!"
echo " 🌐 Live at: https://${S3_BUCKET}.s3-website-${AWS_REGION}.amazonaws.com"
echo "================================================================"

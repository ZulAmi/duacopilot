#!/bin/bash

echo "================================================================"
echo " DuaCopilot Development Deployment to Firebase"
echo "================================================================"
echo

echo "Building Flutter Web App (Development Version)..."
flutter build web --target lib/main_dev.dart --release

if [ $? -ne 0 ]; then
    echo
    echo "❌ Build failed! Please fix the errors above."
    exit 1
fi

echo
echo "✅ Build completed successfully!"
echo

echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting

if [ $? -ne 0 ]; then
    echo
    echo "❌ Deployment failed! Please check your Firebase configuration."
    exit 1
fi

echo
echo "================================================================"
echo " ✅ Development version deployed successfully!"
echo " 🌐 Live at: https://duacopilot.web.app"
echo "================================================================"

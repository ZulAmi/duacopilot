@echo off
echo ================================================================
echo  DuaCopilot Development Deployment to Firebase
echo ================================================================
echo.

echo Building Flutter Web App (Development Version)...
flutter build web --target lib/main_dev.dart --release

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Build failed! Please fix the errors above.
    pause
    exit /b 1
)

echo.
echo ✅ Build completed successfully!
echo.

echo Deploying to Firebase Hosting...
firebase deploy --only hosting

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Deployment failed! Please check your Firebase configuration.
    pause
    exit /b 1
)

echo.
echo ================================================================
echo  ✅ Development version deployed successfully!
echo  🌐 Live at: https://duacopilot.web.app
echo ================================================================
echo.
pause

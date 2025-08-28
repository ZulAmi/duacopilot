# Windows Build Fix Script
# This script temporarily disables Firebase for Windows builds

Write-Host "🔧 DuaCopilot Windows Build Fix Script" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Check if we're in the correct directory
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Error: pubspec.yaml not found. Please run this script from the project root." -ForegroundColor Red
    exit 1
}

Write-Host "📦 Backing up original pubspec.yaml..." -ForegroundColor Yellow
Copy-Item "pubspec.yaml" "pubspec_backup.yaml" -Force

Write-Host "🔄 Using Windows-compatible pubspec.yaml..." -ForegroundColor Yellow
if (Test-Path "pubspec_windows_fix.yaml") {
    Copy-Item "pubspec_windows_fix.yaml" "pubspec.yaml" -Force
} else {
    Write-Host "❌ Error: pubspec_windows_fix.yaml not found." -ForegroundColor Red
    exit 1
}

Write-Host "🧹 Cleaning Flutter build cache..." -ForegroundColor Yellow
flutter clean

Write-Host "📥 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "🏗️ Building Windows app with Firebase disabled..." -ForegroundColor Yellow
flutter run --target lib/main_windows_dev.dart -d windows

# Restore original pubspec.yaml
Write-Host "🔙 Restoring original pubspec.yaml..." -ForegroundColor Yellow
Move-Item "pubspec_backup.yaml" "pubspec.yaml" -Force

Write-Host "✅ Windows build completed!" -ForegroundColor Green
Write-Host "Note: Firebase features are disabled in Windows build for compatibility." -ForegroundColor Cyan

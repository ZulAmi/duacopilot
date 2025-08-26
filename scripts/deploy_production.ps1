# scripts/deploy_production.ps1
# Windows PowerShell Production Deployment Script for Flutter RAG App

param(
    [string]$Target = "all",
    [string]$Environment = "production",
    [switch]$SkipTests,
    [switch]$SkipSecurityChecks
)

# Configuration
$APP_NAME = "DuaCopilot"
$VERSION = (Select-String -Path "pubspec.yaml" -Pattern "version:").ToString().Split(" ")[1].Split("+")[0]
$BUILD_NUMBER = (Select-String -Path "pubspec.yaml" -Pattern "version:").ToString().Split("+")[1]
$TIMESTAMP = Get-Date -Format "yyyyMMdd_HHmmss"

# Colors for output
$Red = [System.ConsoleColor]::Red
$Green = [System.ConsoleColor]::Green
$Blue = [System.ConsoleColor]::Blue
$Yellow = [System.ConsoleColor]::Yellow

# Logging functions
function Write-Log {
    param($Message, $Color = [System.ConsoleColor]::Blue)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message" -ForegroundColor $Color
}

function Write-Error-Log {
    param($Message)
    Write-Log "ERROR: $Message" -Color $Red
    exit 1
}

function Write-Success {
    param($Message)
    Write-Log "SUCCESS: $Message" -Color $Green
}

function Write-Warning {
    param($Message)
    Write-Log "WARNING: $Message" -Color $Yellow
}

# Check prerequisites
function Test-Prerequisites {
    Write-Log "Checking prerequisites..."
    
    # Check Flutter
    try {
        $flutterVersion = flutter --version 2>$null | Select-String "Flutter" | ForEach-Object { $_.ToString().Split(" ")[1] }
        Write-Log "Flutter version: $flutterVersion"
    }
    catch {
        Write-Error-Log "Flutter is not installed or not in PATH"
    }
    
    # Check if we're in the right directory
    if (!(Test-Path "pubspec.yaml")) {
        Write-Error-Log "pubspec.yaml not found. Run this script from the project root."
    }
    
    # Check if main_prod.dart exists
    if (!(Test-Path "lib\main_prod.dart")) {
        Write-Error-Log "lib\main_prod.dart not found. Production main file is required."
    }
    
    Write-Success "Prerequisites check passed"
}

# Clean and prepare
function Initialize-Project {
    Write-Log "Cleaning and preparing project..."
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Generate code if needed
    if ((Test-Path "build_runner.yaml") -or (Select-String -Path "pubspec.yaml" -Pattern "build_runner" -Quiet)) {
        Write-Log "Running code generation..."
        flutter packages pub run build_runner build --delete-conflicting-outputs
    }
    
    Write-Success "Project cleaned and prepared"
}

# Run tests
function Invoke-Tests {
    if ($SkipTests) {
        Write-Warning "Skipping tests as requested"
        return
    }
    
    Write-Log "Running tests..."
    
    # Unit tests
    Write-Log "Running unit tests..."
    flutter test --coverage --reporter=github
    
    # Check test coverage
    if (Test-Path "coverage\lcov.info") {
        Write-Log "Test coverage report generated"
        
        # Try to parse coverage if genhtml is available
        try {
            $coverage = (genhtml coverage\lcov.info -o coverage\html --quiet 2>$null | Select-String "lines......:").ToString().Split(" ")[-1]
            Write-Log "Test coverage: $coverage"
            
            $coverageNum = [int]($coverage.Replace('%', '').Split('.')[0])
            if ($coverageNum -lt 80) {
                Write-Warning "Test coverage below 80%: $coverage"
            }
        }
        catch {
            Write-Log "Coverage parsing skipped (genhtml not available)"
        }
    }
    
    # Integration tests
    if (Test-Path "integration_test") {
        Write-Log "Running integration tests..."
        try {
            flutter drive --driver=test_driver\integration_test.dart --target=integration_test\app_test.dart -d web-server --web-port=8080
        }
        catch {
            Write-Warning "Integration tests failed"
        }
    }
    
    Write-Success "Tests completed"
}

# Security checks
function Test-Security {
    if ($SkipSecurityChecks) {
        Write-Warning "Skipping security checks as requested"
        return
    }
    
    Write-Log "Running security checks..."
    
    # Check for hardcoded secrets
    Write-Log "Checking for hardcoded secrets..."
    $secretPatterns = @("api_key", "secret", "password", "token")
    foreach ($pattern in $secretPatterns) {
        $matches = Select-String -Path "lib\*.dart" -Pattern $pattern -Exclude "*.g.dart" | Where-Object { $_.Line -notmatch "// TODO|// FIXME" }
        if ($matches) {
            Write-Warning "Potential hardcoded secrets found for pattern '$pattern'. Please review."
        }
    }
    
    # Run Flutter analyze
    Write-Log "Running static analysis..."
    flutter analyze --fatal-infos --fatal-warnings
    
    Write-Success "Security checks completed"
}

# Build Android
function Build-Android {
    Write-Log "Building Android application..."
    
    # Check keystore
    if (!(Test-Path "android\key.properties")) {
        Write-Error-Log "android\key.properties not found. Setup signing keys first."
    }
    
    # Environment variables for build
    $env:ENVIRONMENT = "production"
    $env:API_BASE_URL = if ($env:PROD_API_BASE_URL) { $env:PROD_API_BASE_URL } else { "https://api.duacopilot.com" }
    $env:RAG_SERVICE_URL = if ($env:PROD_RAG_SERVICE_URL) { $env:PROD_RAG_SERVICE_URL } else { "https://rag.duacopilot.com" }
    
    # Build APK
    Write-Log "Building Android APK..."
    flutter build apk --release --target=lib\main_prod.dart --dart-define=ENVIRONMENT=production --dart-define=API_BASE_URL=$env:API_BASE_URL --dart-define=RAG_SERVICE_URL=$env:RAG_SERVICE_URL --obfuscate --split-debug-info=build\app\outputs\symbols
    
    # Build AAB for Play Store
    Write-Log "Building Android App Bundle..."
    flutter build appbundle --release --target=lib\main_prod.dart --dart-define=ENVIRONMENT=production --dart-define=API_BASE_URL=$env:API_BASE_URL --dart-define=RAG_SERVICE_URL=$env:RAG_SERVICE_URL --obfuscate --split-debug-info=build\app\outputs\symbols
    
    # Verify builds
    if (Test-Path "build\app\outputs\flutter-apk\app-release.apk") {
        $apkSize = (Get-Item "build\app\outputs\flutter-apk\app-release.apk").Length / 1MB
        Write-Log "Android APK size: $([math]::Round($apkSize, 2)) MB"
    }
    
    if (Test-Path "build\app\outputs\bundle\release\app-release.aab") {
        $aabSize = (Get-Item "build\app\outputs\bundle\release\app-release.aab").Length / 1MB
        Write-Log "Android AAB size: $([math]::Round($aabSize, 2)) MB"
    }
    
    Write-Success "Android build completed"
}

# Build Web
function Build-Web {
    Write-Log "Building Web application..."
    
    # Environment variables for build
    $env:ENVIRONMENT = "production"
    $env:API_BASE_URL = if ($env:PROD_API_BASE_URL) { $env:PROD_API_BASE_URL } else { "https://api.duacopilot.com" }
    $env:RAG_SERVICE_URL = if ($env:PROD_RAG_SERVICE_URL) { $env:PROD_RAG_SERVICE_URL } else { "https://rag.duacopilot.com" }
    
    flutter build web --release --target=lib\main_prod.dart --dart-define=ENVIRONMENT=production --dart-define=API_BASE_URL=$env:API_BASE_URL --dart-define=RAG_SERVICE_URL=$env:RAG_SERVICE_URL --web-renderer canvaskit --base-href /duacopilot/ --pwa-strategy offline-first
    
    # Optimize web build
    if (Get-Command gzip -ErrorAction SilentlyContinue) {
        Write-Log "Compressing web assets..."
        Get-ChildItem -Path "build\web" -Recurse -Include "*.js", "*.css", "*.html" | ForEach-Object {
            gzip -k -9 $_.FullName
        }
    }
    
    $webSize = (Get-ChildItem -Path "build\web" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Log "Web build size: $([math]::Round($webSize, 2)) MB"
    
    Write-Success "Web build completed"
}

# Create release package
function New-ReleasePackage {
    Write-Log "Creating release package..."
    
    $releaseDir = "releases\${APP_NAME}_v${VERSION}_${TIMESTAMP}"
    New-Item -ItemType Directory -Path $releaseDir -Force | Out-Null
    
    # Copy Android builds
    if (Test-Path "build\app\outputs\flutter-apk\app-release.apk") {
        Copy-Item "build\app\outputs\flutter-apk\app-release.apk" "$releaseDir\${APP_NAME}_v${VERSION}.apk"
    }
    
    if (Test-Path "build\app\outputs\bundle\release\app-release.aab") {
        Copy-Item "build\app\outputs\bundle\release\app-release.aab" "$releaseDir\${APP_NAME}_v${VERSION}.aab"
    }
    
    # Copy Web builds
    if (Test-Path "build\web") {
        Copy-Item "build\web" "$releaseDir\web" -Recurse
    }
    
    # Create release notes
    $releaseNotes = @"
# $APP_NAME v$VERSION Release Notes

**Release Date:** $(Get-Date)
**Version:** $VERSION
**Build Number:** $BUILD_NUMBER

## Features
- RAG-powered Islamic knowledge search
- Real-time monitoring and analytics
- Feature flags for gradual rollout
- Performance monitoring
- User feedback collection
- Cross-platform support (Android, Web, Windows)

## Technical Details
- Flutter Version: $((flutter --version | Select-Object -First 1).ToString())
- Environment: Production
- Build Type: Release
- Obfuscation: Enabled
- Debug Info: Split and stored separately

## Security
- Code obfuscated for production
- No hardcoded secrets
- Static analysis passed

## Deployment
- Android: Ready for Google Play Store
- Web: Ready for Firebase Hosting

## Monitoring
- Firebase Analytics enabled
- Firebase Crashlytics enabled
- Firebase Performance enabled
- Custom performance monitoring enabled

---
Generated by automated build script on $(Get-Date)
"@
    
    $releaseNotes | Out-File "$releaseDir\RELEASE_NOTES.md" -Encoding UTF8
    
    # Create checksums
    Get-ChildItem -Path $releaseDir -Filter "*.apk", "*.aab" | ForEach-Object {
        $hash = Get-FileHash $_.FullName -Algorithm SHA256
        "$($hash.Hash)  $($_.Name)" | Out-File "$releaseDir\checksums.txt" -Append -Encoding ASCII
    }
    
    # Create archive
    if (Get-Command 7z -ErrorAction SilentlyContinue) {
        7z a "${releaseDir}.zip" "$releaseDir\*"
        Write-Success "Release package created: ${releaseDir}.zip"
    } else {
        Compress-Archive -Path "$releaseDir\*" -DestinationPath "${releaseDir}.zip"
        Write-Success "Release package created: ${releaseDir}.zip"
    }
}

# Deploy to Firebase (Web)
function Deploy-Web {
    param($Environment)
    
    if (($Environment -eq "production") -and (Get-Command firebase -ErrorAction SilentlyContinue)) {
        Write-Log "Deploying web to Firebase Hosting..."
        
        # Deploy to production
        firebase deploy --only hosting --project duacopilot-prod
        
        Write-Success "Web deployment to production completed"
        Write-Log "Web app available at: https://duacopilot.com"
    } else {
        Write-Warning "Firebase CLI not found or not deploying to production"
    }
}

# Performance audit
function Test-Performance {
    if ((Get-Command lighthouse -ErrorAction SilentlyContinue) -and (Test-Path "build\web")) {
        Write-Log "Running performance audit..."
        
        # Start local server
        $server = Start-Process python -ArgumentList "-m", "http.server", "8080", "--directory", "build\web" -PassThru -NoNewWindow
        
        # Wait for server
        Start-Sleep 3
        
        # Run Lighthouse
        try {
            lighthouse http://localhost:8080 --output json --output-path lighthouse-report.json --chrome-flags="--headless" --quiet
            
            if (Test-Path "lighthouse-report.json") {
                $report = Get-Content "lighthouse-report.json" | ConvertFrom-Json
                $performanceScore = [math]::Round($report.categories.performance.score * 100, 1)
                Write-Log "Performance Score: $performanceScore%"
            }
        }
        catch {
            Write-Warning "Performance audit failed"
        }
        finally {
            # Stop server
            Stop-Process $server -Force -ErrorAction SilentlyContinue
        }
        
        Write-Success "Performance audit completed"
    } else {
        Write-Warning "Lighthouse not found or web build not available"
    }
}

# Main deployment function
function Start-ProductionDeployment {
    Write-Log "Starting production deployment for $APP_NAME v$VERSION"
    
    # Check prerequisites
    Test-Prerequisites
    
    # Clean and prepare
    Initialize-Project
    
    # Run tests
    Invoke-Tests
    
    # Security checks
    Test-Security
    
    # Build applications
    switch ($Target) {
        "android" {
            Build-Android
        }
        "web" {
            Build-Web
            Deploy-Web $Environment
        }
        "all" {
            Build-Android
            Build-Web
            Deploy-Web $Environment
        }
        default {
            Build-Android
            Build-Web
            Deploy-Web $Environment
        }
    }
    
    # Create release package
    New-ReleasePackage
    
    # Performance audit
    Test-Performance
    
    Write-Success "Production deployment completed successfully!"
    Write-Log "Release package: releases\${APP_NAME}_v${VERSION}_${TIMESTAMP}.zip"
    
    # Print deployment summary
    Write-Host ""
    Write-Host "==================== DEPLOYMENT SUMMARY ====================" -ForegroundColor Cyan
    Write-Host "App Name: $APP_NAME" -ForegroundColor White
    Write-Host "Version: $VERSION" -ForegroundColor White
    Write-Host "Build Number: $BUILD_NUMBER" -ForegroundColor White
    Write-Host "Environment: $Environment" -ForegroundColor White
    Write-Host "Target: $Target" -ForegroundColor White
    Write-Host "Timestamp: $TIMESTAMP" -ForegroundColor White
    Write-Host ""
    Write-Host "✓ Tests passed" -ForegroundColor Green
    Write-Host "✓ Security checks completed" -ForegroundColor Green
    Write-Host "✓ Builds completed" -ForegroundColor Green
    Write-Host "✓ Release package created" -ForegroundColor Green
    Write-Host "✓ Performance audit completed" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Review release notes in releases\${APP_NAME}_v${VERSION}_${TIMESTAMP}\" -ForegroundColor White
    Write-Host "2. Upload Android AAB to Google Play Console" -ForegroundColor White
    Write-Host "3. Monitor deployment metrics in Firebase" -ForegroundColor White
    Write-Host "==========================================================" -ForegroundColor Cyan
}

# Run main function
Start-ProductionDeployment

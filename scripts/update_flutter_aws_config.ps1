# Update Flutter App Configuration for AWS Backend
# Run this after successful AWS backend deployment

param(
    [Parameter(Mandatory=$true)]
    [string]$ApiGatewayUrl,
    
    [Parameter(Mandatory=$false)]
    [string]$WebSocketUrl,
    
    [Parameter(Mandatory=$false)]
    [string]$Stage = "prod"
)

Write-Host "🔧 Updating Flutter App Configuration for AWS Backend..." -ForegroundColor Green

# Update app_config.dart with new AWS endpoints
$appConfigPath = "lib/core/config/app_config.dart"
$awsConfigPath = "lib/core/config/aws_config.dart"

# Backup original configuration
if (Test-Path $appConfigPath) {
    Copy-Item $appConfigPath "$appConfigPath.backup" -Force
    Write-Host "✅ Backed up original app_config.dart" -ForegroundColor Yellow
}

# Update AWS configuration file with actual endpoints
$awsConfigContent = Get-Content $awsConfigPath -Raw
$awsConfigContent = $awsConfigContent -replace "YOUR-API-ID.execute-api.us-east-1.amazonaws.com", $ApiGatewayUrl.Replace("https://", "").Replace("/prod", "")

if ($WebSocketUrl) {
    $wsUrl = $WebSocketUrl.Replace("wss://", "").Replace("/prod", "")
    $awsConfigContent = $awsConfigContent -replace "YOUR-WS-ID.execute-api.us-east-1.amazonaws.com", $wsUrl
}

Set-Content $awsConfigPath $awsConfigContent -Encoding UTF8
Write-Host "✅ Updated AWS configuration with deployment endpoints" -ForegroundColor Green

# Update app_config.dart to use AWS endpoints instead of hardcoded ones
$appConfigContent = Get-Content $appConfigPath -Raw

# Replace hardcoded URLs with AWS configuration
$replacements = @{
    "https://api.duacopilot.com" = "AWSConfig.baseUrl"
    "https://rag.duacopilot.com" = "AWSConfig.baseUrl"
    "wss://api.duacopilot.com/ws" = "AWSConfig.webSocket"
    "https://duacopilot.com/api" = "AWSConfig.baseUrl"
}

foreach ($old in $replacements.Keys) {
    $new = $replacements[$old]
    if ($appConfigContent -match [regex]::Escape($old)) {
        Write-Host "🔄 Replacing $old with $new" -ForegroundColor Blue
        $appConfigContent = $appConfigContent -replace [regex]::Escape($old), $new
    }
}

# Ensure AWS config is imported
if (-not ($appConfigContent -match "import.*aws_config\.dart")) {
    $import = "import 'aws_config.dart';"
    if ($appConfigContent -match "import\s") {
        $appConfigContent = $appConfigContent -replace "(import[^;]+;)", "`$1`n$import"
    } else {
        $appConfigContent = "$import`n$appConfigContent"
    }
    Write-Host "✅ Added AWS config import" -ForegroundColor Green
}

Set-Content $appConfigPath $appConfigContent -Encoding UTF8
Write-Host "✅ Updated app_config.dart to use AWS endpoints" -ForegroundColor Green

# Update environment-specific configuration files
$envFiles = @(
    "lib/core/config/environment_config.dart",
    "lib/core/config/dev_config.dart",
    "lib/core/config/prod_config.dart"
)

foreach ($envFile in $envFiles) {
    if (Test-Path $envFile) {
        $envContent = Get-Content $envFile -Raw
        foreach ($old in $replacements.Keys) {
            $new = $replacements[$old]
            if ($envContent -match [regex]::Escape($old)) {
                Write-Host "🔄 Updating $envFile" -ForegroundColor Blue
                $envContent = $envContent -replace [regex]::Escape($old), $new
            }
        }
        Set-Content $envFile $envContent -Encoding UTF8
    }
}

Write-Host "`n🚀 Flutter app configuration updated successfully!" -ForegroundColor Green
Write-Host "📋 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Run 'flutter clean' to clear build cache" -ForegroundColor White
Write-Host "   2. Run 'flutter pub get' to refresh dependencies" -ForegroundColor White
Write-Host "   3. Test the app to ensure AWS backend connectivity" -ForegroundColor White
Write-Host "   4. Rebuild and redeploy to AWS S3 if needed" -ForegroundColor White

# Verify configuration
Write-Host "`n🔍 Configuration Summary:" -ForegroundColor Cyan
Write-Host "   API Gateway URL: $ApiGatewayUrl" -ForegroundColor White
if ($WebSocketUrl) {
    Write-Host "   WebSocket URL: $WebSocketUrl" -ForegroundColor White
}
Write-Host "   Stage: $Stage" -ForegroundColor White
Write-Host "   AWS Config: $awsConfigPath" -ForegroundColor White
Write-Host "   App Config: $appConfigPath" -ForegroundColor White

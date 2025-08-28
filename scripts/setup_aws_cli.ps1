# AWS CLI Setup Helper for DuaCopilot
# This script helps configure AWS CLI when the PATH is not working properly

Write-Host "🚀 AWS CLI Setup Helper" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

# Define AWS CLI path
$awsPath = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

# Check if AWS CLI exists
if (Test-Path $awsPath) {
    Write-Host "✅ AWS CLI found at: $awsPath" -ForegroundColor Green
} else {
    Write-Host "❌ AWS CLI not found. Please install it from:" -ForegroundColor Red
    Write-Host "   https://awscli.amazonaws.com/AWSCLIV2.msi" -ForegroundColor Yellow
    exit 1
}

# Test AWS CLI
try {
    $version = & $awsPath --version 2>&1
    Write-Host "✅ AWS CLI Version: $version" -ForegroundColor Green
} catch {
    Write-Host "❌ Error testing AWS CLI: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔧 Configuration Options:" -ForegroundColor Cyan
Write-Host "1. Configure AWS credentials interactively" -ForegroundColor White
Write-Host "2. Show current AWS configuration" -ForegroundColor White
Write-Host "3. Test AWS connection" -ForegroundColor White
Write-Host "4. Add AWS to PATH permanently" -ForegroundColor White
Write-Host "5. Exit" -ForegroundColor White

do {
    Write-Host ""
    $choice = Read-Host "Select option (1-5)"
    
    switch ($choice) {
        "1" {
            Write-Host "🔐 Configuring AWS credentials..." -ForegroundColor Blue
            Write-Host "You'll need:" -ForegroundColor Yellow
            Write-Host "- AWS Access Key ID" -ForegroundColor Yellow
            Write-Host "- AWS Secret Access Key" -ForegroundColor Yellow
            Write-Host "- Default region (recommend: us-east-1)" -ForegroundColor Yellow
            Write-Host "- Output format (recommend: json)" -ForegroundColor Yellow
            Write-Host ""
            & $awsPath configure
        }
        "2" {
            Write-Host "📋 Current AWS configuration:" -ForegroundColor Blue
            & $awsPath configure list
        }
        "3" {
            Write-Host "🧪 Testing AWS connection..." -ForegroundColor Blue
            try {
                $identity = & $awsPath sts get-caller-identity --output json | ConvertFrom-Json
                Write-Host "✅ Connected as User ID: $($identity.UserId)" -ForegroundColor Green
                Write-Host "   Account: $($identity.Account)" -ForegroundColor Green
                Write-Host "   ARN: $($identity.Arn)" -ForegroundColor Green
            } catch {
                Write-Host "❌ AWS connection failed. Please configure credentials first." -ForegroundColor Red
            }
        }
        "4" {
            Write-Host "🛠️ Adding AWS CLI to PATH..." -ForegroundColor Blue
            $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
            $awsDir = "C:\Program Files\Amazon\AWSCLIV2"
            
            if ($currentPath -notlike "*$awsDir*") {
                [Environment]::SetEnvironmentVariable("Path", "$currentPath;$awsDir", "User")
                Write-Host "✅ AWS CLI added to PATH. Please restart PowerShell to use 'aws' command." -ForegroundColor Green
            } else {
                Write-Host "✅ AWS CLI already in PATH" -ForegroundColor Green
            }
        }
        "5" {
            Write-Host "👋 Goodbye!" -ForegroundColor Green
            exit 0
        }
        default {
            Write-Host "❌ Invalid option. Please select 1-5." -ForegroundColor Red
        }
    }
} while ($true)

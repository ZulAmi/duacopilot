#!/usr/bin/env powershell
# DuaCopilot Backend AWS Deployment Preparation Script

param(
    [switch]$CheckOnly,
    [switch]$FixIssues,
    [switch]$SetupEnvironment
)

Write-Host "🔍 DuaCopilot Backend AWS Deployment Readiness Check" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Gray
Write-Host ""

$ErrorCount = 0
$WarningCount = 0

function Test-Requirement {
    param($Name, $Test, $FixAction, [switch]$Critical)
    
    Write-Host "Checking $Name..." -NoNewline
    
    if (& $Test) {
        Write-Host " ✅ PASS" -ForegroundColor Green
        return $true
    } else {
        if ($Critical) {
            Write-Host " ❌ FAIL (Critical)" -ForegroundColor Red
            $script:ErrorCount++
        } else {
            Write-Host " ⚠️  WARN" -ForegroundColor Yellow
            $script:WarningCount++
        }
        
        if ($FixIssues -and $FixAction) {
            Write-Host "   Attempting fix..." -ForegroundColor Blue
            & $FixAction
        }
        return $false
    }
}

# 1. Environment Variables Check
Write-Host "📋 Environment Variables" -ForegroundColor Yellow
Write-Host "------------------------"

Test-Requirement "OPENAI_API_KEY" {
    return $env:OPENAI_API_KEY -ne $null -and $env:OPENAI_API_KEY -ne ""
} {
    Write-Host "   Please set OPENAI_API_KEY environment variable"
    Write-Host "   Example: `$env:OPENAI_API_KEY = 'sk-...'"
} -Critical

Test-Requirement "AWS Credentials" {
    try {
        $identity = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" sts get-caller-identity --output json 2>$null | ConvertFrom-Json
        return $identity.Account -ne $null
    } catch {
        return $false
    }
} {
    Write-Host "   Run: aws configure"
} -Critical

Test-Requirement "JWT_SECRET" {
    return $env:JWT_SECRET -ne $null -and $env:JWT_SECRET.Length -ge 32
} {
    $env:JWT_SECRET = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((New-Guid).Guid + (New-Guid).Guid))
    Write-Host "   Generated JWT_SECRET: $env:JWT_SECRET"
}

# 2. Dependencies Check  
Write-Host ""
Write-Host "📦 Dependencies & Tools" -ForegroundColor Yellow
Write-Host "-----------------------"

Test-Requirement "Node.js" {
    try {
        $version = node --version
        $majorVersion = [int]($version.Substring(1).Split('.')[0])
        return $majorVersion -ge 18
    } catch {
        return $false
    }
} {
    Write-Host "   Please install Node.js 18+ from https://nodejs.org/"
} -Critical

Test-Requirement "AWS CLI" {
    try {
        & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" --version | Out-Null
        return $true
    } catch {
        return $false
    }
} {
    Write-Host "   Install AWS CLI from: https://aws.amazon.com/cli/"
} -Critical

Test-Requirement "Firebase Functions Build" {
    return Test-Path "firebase/functions/lib"
} {
    Write-Host "   Building Firebase Functions..."
    cd firebase/functions
    npm run build
    cd ../..
}

# 3. Backend Structure Check
Write-Host ""
Write-Host "🏗️  Backend Structure" -ForegroundColor Yellow
Write-Host "--------------------"

Test-Requirement "AWS Backend Directory" {
    return Test-Path "aws-backend"
} {
    New-Item -ItemType Directory -Path "aws-backend" -Force
}

Test-Requirement "Backend Package.json" {
    return Test-Path "aws-backend/package.json"
} {
    Write-Host "   Backend package.json already created"
}

Test-Requirement "Lambda Handlers" {
    return Test-Path "aws-backend/src/handlers.ts"
} {
    Write-Host "   Lambda handlers already created"
}

# 4. Configuration Files Check
Write-Host ""
Write-Host "⚙️  Configuration Files" -ForegroundColor Yellow
Write-Host "----------------------"

Test-Requirement "Serverless Config" {
    return Test-Path "aws-backend/serverless.yml"
} {
    Write-Host "   Serverless configuration already created"
}

Test-Requirement "Environment File" {
    return Test-Path "aws-backend/.env.example"
} {
    Write-Host "   Environment template already created"
}

Test-Requirement "TypeScript Config" {
    return Test-Path "aws-backend/tsconfig.json"
} {
    $tsConfig = @"
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
"@
    $tsConfig | Out-File "aws-backend/tsconfig.json" -Encoding utf8
}

# 5. Migration Preparation
Write-Host ""
Write-Host "🔄 Migration Preparation" -ForegroundColor Yellow
Write-Host "------------------------"

if ($SetupEnvironment) {
    Write-Host "Setting up AWS backend environment..." -ForegroundColor Blue
    
    # Create .env file from example
    if (Test-Path "aws-backend/.env.example" -and !(Test-Path "aws-backend/.env")) {
        Copy-Item "aws-backend/.env.example" "aws-backend/.env"
        Write-Host "✅ Created .env file from template" -ForegroundColor Green
        Write-Host "⚠️  Please edit aws-backend/.env with your actual values" -ForegroundColor Yellow
    }
    
    # Install dependencies
    Write-Host "Installing AWS backend dependencies..." -ForegroundColor Blue
    cd aws-backend
    try {
        npm install
        Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
        $script:ErrorCount++
    }
    cd ..
}

# 6. Final Assessment
Write-Host ""
Write-Host "📊 DEPLOYMENT READINESS ASSESSMENT" -ForegroundColor Cyan
Write-Host "==================================="

if ($ErrorCount -eq 0 -and $WarningCount -eq 0) {
    Write-Host "🎉 READY FOR DEPLOYMENT!" -ForegroundColor Green -BackgroundColor DarkGreen
    Write-Host ""
    Write-Host "Your backend is ready for AWS deployment. Next steps:" -ForegroundColor Green
    Write-Host "1. Set environment variables in aws-backend/.env" -ForegroundColor White
    Write-Host "2. Run: .\scripts\deploy_backend_aws.ps1 -DeploymentType serverless" -ForegroundColor White
    Write-Host "3. Update Flutter app with new API endpoints" -ForegroundColor White
} elseif ($ErrorCount -eq 0) {
    Write-Host "⚠️  MOSTLY READY - $WarningCount warnings" -ForegroundColor Yellow -BackgroundColor DarkYellow
    Write-Host ""
    Write-Host "You can deploy but should address warnings first:" -ForegroundColor Yellow
    Write-Host "Run with -FixIssues to automatically fix some issues" -ForegroundColor White
} else {
    Write-Host "❌ NOT READY - $ErrorCount critical issues" -ForegroundColor Red -BackgroundColor DarkRed
    Write-Host ""
    Write-Host "Critical issues must be resolved before deployment:" -ForegroundColor Red
    Write-Host "Run with -FixIssues -SetupEnvironment to automatically fix issues" -ForegroundColor White
}

Write-Host ""
Write-Host "Run options:" -ForegroundColor Cyan
Write-Host "  .\scripts\prepare_backend_aws.ps1 -CheckOnly" -ForegroundColor White
Write-Host "  .\scripts\prepare_backend_aws.ps1 -FixIssues" -ForegroundColor White  
Write-Host "  .\scripts\prepare_backend_aws.ps1 -SetupEnvironment" -ForegroundColor White
Write-Host "  .\scripts\prepare_backend_aws.ps1 -FixIssues -SetupEnvironment" -ForegroundColor White

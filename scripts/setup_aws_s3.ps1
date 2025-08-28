# AWS S3 Setup Script for DuaCopilot
# Run this after configuring AWS CLI

param(
    [string]$BucketName = "duacopilot-web-$(Get-Random -Maximum 9999)",
    [string]$Region = "us-east-1"
)

Write-Host "🚀 Setting up AWS S3 for DuaCopilot deployment..." -ForegroundColor Cyan
Write-Host "Bucket Name: $BucketName" -ForegroundColor Yellow
Write-Host "Region: $Region" -ForegroundColor Yellow

# Check if AWS CLI is configured
try {
    $identity = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" sts get-caller-identity --output json | ConvertFrom-Json
    Write-Host "✅ AWS CLI configured for user: $($identity.UserId)" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI not configured. Please run 'aws configure' first." -ForegroundColor Red
    exit 1
}

# Create S3 bucket
Write-Host "📦 Creating S3 bucket..." -ForegroundColor Blue
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" s3 mb s3://$BucketName --region $Region

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ S3 bucket created successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to create S3 bucket" -ForegroundColor Red
    exit 1
}

# Configure bucket for static website hosting
Write-Host "🌐 Configuring static website hosting..." -ForegroundColor Blue
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" s3 website s3://$BucketName --index-document index.html --error-document index.html

# Create bucket policy for public read access
$policyJson = @"
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BucketName/*"
        }
    ]
}
"@

$policyJson | Out-File -FilePath "bucket-policy.json" -Encoding utf8
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" s3api put-bucket-policy --bucket $BucketName --policy file://bucket-policy.json
Remove-Item "bucket-policy.json" -Force

# Disable block public access
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" s3api put-public-access-block --bucket $BucketName --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

Write-Host "🎉 S3 setup completed!" -ForegroundColor Green
Write-Host "📝 Save these details:" -ForegroundColor Cyan
Write-Host "   Bucket Name: $BucketName" -ForegroundColor White
Write-Host "   Website URL: http://$BucketName.s3-website-$Region.amazonaws.com" -ForegroundColor White
Write-Host "   Region: $Region" -ForegroundColor White

Write-Host ""
Write-Host "🔧 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update your GitHub secrets with the bucket name" -ForegroundColor White
Write-Host "2. Run the deployment script or push to aws-deploy branch" -ForegroundColor White

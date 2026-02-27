# Quick Terraform Deployment Script (Windows)

param(
    [string]$Environment = "dev"
)

Write-Host "🚀 Starting Terraform Deployment..." -ForegroundColor Green
Write-Host "📋 Environment: $Environment" -ForegroundColor Cyan

# Initialize Terraform
Write-Host "🔧 Initializing Terraform..." -ForegroundColor Yellow
terraform init

# Select workspace
Write-Host "🔄 Selecting workspace: $Environment" -ForegroundColor Yellow
terraform workspace select $Environment
if ($LASTEXITCODE -ne 0) {
    terraform workspace new $Environment
}

# Plan
Write-Host "📊 Running Terraform Plan..." -ForegroundColor Yellow
terraform plan -var-file="environments\$Environment.tfvars"

# Ask for confirmation
$confirm = Read-Host "🤔 Apply changes? (yes/no)"

if ($confirm -eq "yes") {
    Write-Host "✅ Applying Terraform..." -ForegroundColor Green
    terraform apply -var-file="environments\$Environment.tfvars" -auto-approve
    Write-Host "🎉 Deployment Complete!" -ForegroundColor Green
} else {
    Write-Host "❌ Deployment Cancelled" -ForegroundColor Red
}

#!/bin/bash

# Quick Terraform Deployment Script

echo "🚀 Starting Terraform Deployment..."

# Check if environment is provided
ENV=${1:-dev}

echo "📋 Environment: $ENV"

# Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Select workspace
echo "🔄 Selecting workspace: $ENV"
terraform workspace select $ENV || terraform workspace new $ENV

# Plan
echo "📊 Running Terraform Plan..."
terraform plan -var-file="environments/${ENV}.tfvars"

# Ask for confirmation
read -p "🤔 Apply changes? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
    echo "✅ Applying Terraform..."
    terraform apply -var-file="environments/${ENV}.tfvars" -auto-approve
    echo "🎉 Deployment Complete!"
else
    echo "❌ Deployment Cancelled"
fi

#!/bin/bash

# Terraform Destroy Script

echo "🗑️  Terraform Destroy Script"

# Check if environment is provided
ENV=${1:-dev}

echo "⚠️  Environment: $ENV"
echo "⚠️  This will destroy all infrastructure!"

# Ask for confirmation
read -p "🚨 Are you sure? Type 'destroy' to confirm: " confirm

if [ "$confirm" = "destroy" ]; then
    echo "🔧 Initializing Terraform..."
    terraform init
    
    echo "🔄 Selecting workspace: $ENV"
    terraform workspace select $ENV
    
    echo "💥 Destroying infrastructure..."
    terraform destroy -var-file="environments/${ENV}.tfvars" -auto-approve
    
    echo "✅ Infrastructure Destroyed!"
else
    echo "❌ Destroy Cancelled"
fi

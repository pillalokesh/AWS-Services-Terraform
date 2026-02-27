#!/bin/bash

# Terraform Validation Script

echo "✅ Terraform Validation Script"
echo ""

# Check Terraform installation
echo "🔍 Checking Terraform..."
if command -v terraform &> /dev/null; then
    echo "✅ Terraform installed: $(terraform version | head -n 1)"
else
    echo "❌ Terraform not installed"
    exit 1
fi

# Check AWS CLI
echo "🔍 Checking AWS CLI..."
if command -v aws &> /dev/null; then
    echo "✅ AWS CLI installed: $(aws --version)"
else
    echo "❌ AWS CLI not installed"
fi

# Format check
echo ""
echo "🔍 Checking Terraform formatting..."
terraform fmt -check -recursive

# Validate
echo ""
echo "🔍 Validating Terraform configuration..."
terraform init -backend=false
terraform validate

echo ""
echo "✅ Validation Complete!"

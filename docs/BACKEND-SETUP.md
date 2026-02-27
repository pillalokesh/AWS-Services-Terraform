# 🗄️ Terraform Backend Setup Guide

## Manual AWS Setup Commands

### Create S3 Bucket for State Storage

```bash
# Create the S3 bucket
aws s3api create-bucket \
  --bucket tarraform-lokesh-services01 \
  --region us-east-1

# Enable versioning (recommended for state file recovery)
aws s3api put-bucket-versioning \
  --bucket tarraform-lokesh-services01 \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket tarraform-lokesh-services01 \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Block public access
aws s3api put-public-access-block \
  --bucket tarraform-lokesh-services01 \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

### Initialize Terraform with Backend

```bash
# Navigate to project directory
cd "c:\Users\mahesh pilla\AWS-Services-Terraform"

# Initialize Terraform (will migrate state to S3)
terraform init

# If you have existing local state, type 'yes' to migrate
```

---

## ✅ Verification

```bash
# Verify S3 bucket exists
aws s3 ls | grep tarraform-lokesh-services01

# Check if state file is in S3 (after terraform init)
aws s3 ls s3://tarraform-lokesh-services01/
```

---

## 🔧 Alternative: AWS Console Setup

1. Go to S3 Console
2. Click "Create bucket"
3. Name: `tarraform-lokesh-services01`
4. Region: `us-east-1`
5. Enable "Bucket Versioning"
6. Enable "Default encryption" (SSE-S3)
7. Block all public access
8. Click "Create bucket"

---

## 📝 What This Does

- **S3 Bucket**: Stores terraform.tfstate file remotely
- **Versioning**: Keeps history of state changes for recovery
- **Encryption**: Protects sensitive data in state file

---

## 💰 Cost

- **S3**: ~$0.023/GB/month (state files are typically < 1MB)
- **Total**: < $0.10/month

---

## 🚨 Important Notes

- Create S3 bucket BEFORE running `terraform init`
- Never delete the S3 bucket while infrastructure exists
- State file contains sensitive data (passwords, keys)
- Keep bucket private and encrypted
- Without DynamoDB locking, avoid concurrent terraform runs

# 🚀 GitHub Actions CI/CD Setup Guide

## 📋 Overview

This guide explains how to set up and use the GitHub Actions workflow for automated AWS infrastructure deployment.

---

## 🔄 Deployment Flow

### **Correct Service Creation Order:**

```
1. VPC (Network Foundation)
   ↓
2. Security Groups (Firewall Rules)
   ↓
3. S3 + IAM (Storage & Permissions)
   ↓
4. EC2 + RDS (Compute & Database)
   ↓
5. CloudWatch + Auto Scaling + ALB (Monitoring & Load Balancing)
   ↓
6. CloudFront + Route53 + Lambda (CDN, DNS & Serverless)
```

**Why This Order?**
- VPC must exist before any resources
- Security Groups need VPC ID
- EC2/RDS need VPC, Security Groups, and IAM
- ALB needs EC2 instances
- CloudFront needs S3 bucket
- Route53 needs CloudFront distribution
- Lambda needs VPC, RDS, and S3

---

## 🎯 Workflow Stages

### **1. Validate** (Runs on every push/PR)
- ✅ Checks Terraform formatting
- ✅ Validates syntax
- ✅ Ensures configuration is valid

### **2. Security Scan** (Runs after validation)
- 🔒 Scans for security vulnerabilities
- 🔒 Checks best practices
- 🔒 Uses Checkov for IaC scanning

### **3. Plan** (Runs after security scan)
- 📋 Shows what will be created/changed
- 📋 Uploads plan as artifact
- 📋 Comments plan on Pull Requests

### **4. Deploy** (Runs on main branch or manual trigger)
- 🚀 Applies infrastructure changes
- 🚀 Creates all AWS resources
- 🚀 Outputs deployment URLs

### **5. Destroy** (Manual trigger only)
- 🗑️ Removes all infrastructure
- 🗑️ Requires approval
- 🗑️ Use with caution!

---

## ⚙️ GitHub Setup

### **Step 1: Configure GitHub Secrets**

Go to: `Settings → Secrets and variables → Actions → New repository secret`

**Required Secrets:**
```
AWS_ACCESS_KEY_ID          # Your AWS access key
AWS_SECRET_ACCESS_KEY      # Your AWS secret key
DB_PASSWORD                # RDS database password
ALARM_EMAIL                # Email for CloudWatch alerts (optional)
```

### **Step 2: Configure GitHub Environments**

Go to: `Settings → Environments → New environment`

**Create These Environments:**

1. **dev** (Development)
   - No protection rules
   - Auto-deploys on dev branch

2. **staging** (Staging)
   - Optional: Require reviewers
   - Auto-deploys on staging branch

3. **prod** (Production)
   - ✅ Required reviewers (1-2 people)
   - ✅ Wait timer: 5 minutes
   - Auto-deploys on main branch

4. **destroy-approval** (For Destroy Job)
   - ✅ Required reviewers (2+ people)
   - ✅ Only for infrastructure destruction

**Add Environment Secrets (if different per environment):**
- Go to each environment
- Add environment-specific secrets if needed

---

## 🔐 AWS IAM Setup

### **Create IAM User for GitHub Actions:**

```bash
# 1. Create IAM user
aws iam create-user --user-name github-actions-terraform

# 2. Attach policies
aws iam attach-user-policy \
  --user-name github-actions-terraform \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# 3. Create access keys
aws iam create-access-key --user-name github-actions-terraform
```

**Save the Access Key ID and Secret Access Key** → Add to GitHub Secrets

---

## 📝 Usage Instructions

### **Automatic Deployment:**

**Push to dev branch:**
```bash
git checkout dev
git add .
git commit -m "Update infrastructure"
git push origin dev
```
→ Automatically validates, scans, plans, and deploys to dev environment

**Push to main branch:**
```bash
git checkout main
git merge dev
git push origin main
```
→ Automatically deploys to production (after approval)

---

### **Manual Deployment:**

1. Go to: `Actions → Deploy AWS Infrastructure → Run workflow`
2. Select branch: `main`
3. Choose environment: `dev`, `staging`, or `prod`
4. Click: `Run workflow`

---

### **Pull Request Workflow:**

```bash
# 1. Create feature branch
git checkout -b feature/new-service

# 2. Make changes
# Edit Terraform files...

# 3. Commit and push
git add .
git commit -m "Add new service"
git push origin feature/new-service

# 4. Create Pull Request on GitHub
# → Workflow automatically runs validate, scan, and plan
# → Plan is commented on PR
# → Review and merge
```

---

## 🔍 Monitoring Deployments

### **View Workflow Runs:**
- Go to: `Actions` tab
- Click on workflow run
- View logs for each job

### **Check Deployment Status:**
- ✅ Green checkmark = Success
- ❌ Red X = Failed
- 🟡 Yellow dot = In progress

### **View Deployment Summary:**
- Click on completed workflow
- Scroll to bottom
- See deployment URLs and details

---

## 🛠️ Troubleshooting

### **Issue: AWS Credentials Invalid**
**Solution:**
```bash
# Verify credentials locally
aws sts get-caller-identity

# Update GitHub secrets if needed
```

### **Issue: Terraform State Lock**
**Solution:**
```bash
# Manually unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

### **Issue: Resource Already Exists**
**Solution:**
```bash
# Import existing resource
terraform import <resource_type>.<name> <resource_id>
```

### **Issue: Workflow Fails on Plan**
**Solution:**
- Check Terraform syntax
- Verify variable files exist
- Review error logs in Actions tab

---

## 📊 Best Practices

### **1. Branch Strategy:**
```
feature/* → dev → staging → main
```

### **2. Never Commit:**
- ❌ `*.tfstate` files
- ❌ `*.tfvars` with secrets
- ❌ AWS credentials
- ❌ `.terraform/` directory

### **3. Always:**
- ✅ Review plan before apply
- ✅ Use Pull Requests
- ✅ Test in dev first
- ✅ Get approval for prod
- ✅ Monitor CloudWatch after deployment

### **4. Cost Management:**
- 💰 Destroy dev/staging when not in use
- 💰 Use t3.micro for non-prod
- 💰 Enable AWS Budget alerts

---

## 🔄 Workflow Triggers

| Trigger | When | Environment | Auto-Deploy |
|---------|------|-------------|-------------|
| Push to `dev` | Code pushed | dev | ✅ Yes |
| Push to `staging` | Code pushed | staging | ✅ Yes |
| Push to `main` | Code pushed | prod | ✅ Yes (with approval) |
| Pull Request | PR created | N/A | ❌ No (plan only) |
| Manual | Button click | Choose | ✅ Yes |

---

## 📈 Advanced Configuration

### **Add Terraform Backend (S3):**

Create `backend.tf`:
```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```

Update workflow to use backend:
```yaml
- name: Terraform Init
  run: terraform init
  # Backend config is now in backend.tf
```

### **Add Slack Notifications:**

Add to workflow:
```yaml
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 📞 Support

**Common Commands:**

```bash
# View workflow logs
gh run list
gh run view <run-id>

# Trigger workflow manually
gh workflow run deploy.yml -f environment=dev

# Check workflow status
gh run watch
```

---

## ✅ Checklist Before First Deployment

- [ ] AWS credentials added to GitHub Secrets
- [ ] GitHub Environments configured (dev, staging, prod)
- [ ] Reviewers assigned to prod environment
- [ ] `.tfvars` files created for each environment
- [ ] S3 bucket name is globally unique
- [ ] Email configured for CloudWatch alarms
- [ ] AWS account verified for CloudFront
- [ ] Tested locally with `terraform plan`
- [ ] Reviewed estimated costs
- [ ] Team notified about deployment

---

**Created by**: DevOps Team  
**Last Updated**: 2024  
**Workflow Version**: 1.0

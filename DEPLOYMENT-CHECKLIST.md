# ✅ Pre-Deployment Checklist

## 🔧 AWS Setup (Manual)

### 1. Create S3 Bucket for Terraform State
```bash
aws s3api create-bucket --bucket tarraform-lokesh-services01 --region us-east-1
aws s3api put-bucket-versioning --bucket tarraform-lokesh-services01 --versioning-configuration Status=Enabled
```
**Status:** ⬜ Not Done | ✅ Done

---

### 2. Create OIDC Provider
1. IAM Console → Identity providers → Add provider
2. Provider URL: `https://token.actions.githubusercontent.com`
3. Audience: `sts.amazonaws.com`
4. Click "Get thumbprint" → Add provider

**Status:** ⬜ Not Done | ✅ Done

---

### 3. Create IAM Role
1. IAM Console → Roles → Create role
2. Web identity → `token.actions.githubusercontent.com`
3. Audience: `sts.amazonaws.com`
4. Add condition:
   - Key: `token.actions.githubusercontent.com:sub`
   - Operator: `StringLike`
   - Value: `repo:YOUR_USERNAME/AWS-Services-Terraform:*`
5. Role name: `AWS-TERRAFORM-ALL-SERVICES`

**Status:** ⬜ Not Done | ✅ Done

---

### 4. Attach Policy to Role
1. IAM → Policies → Create policy
2. Use JSON from `policies/github-actions-policy.json`
3. Name: `GitHubActionsTerraformPolicy`
4. Attach to role: `AWS-TERRAFORM-ALL-SERVICES`

**Status:** ⬜ Not Done | ✅ Done

---

## 🔐 GitHub Secrets Setup

Go to: **GitHub Repo → Settings → Secrets and variables → Actions**

### Required Secrets:
- [ ] `AWS_ROLE_ARN` = `arn:aws:iam::056026787582:role/AWS-TERRAFORM-ALL-SERVICES`
- [ ] `DB_PASSWORD` = Your RDS password
- [ ] `ALARM_EMAIL` = Your email for alerts (optional)

**Status:** ⬜ Not Done | ✅ Done

---

## 📝 Configuration Files

### 1. Update Environment Variables
Edit `environments/dev.tfvars`:
- [ ] Update `bucket_name` (must be globally unique)
- [ ] Update `ami_id` (check latest AMI for your region)
- [ ] Set `alarm_email` if needed
- [ ] Configure RDS settings if using database

**Status:** ⬜ Not Done | ✅ Done

---

### 2. Verify File Paths
- [ ] `assets/index.html` exists
- [ ] `assets/lambda_function.py` exists
- [ ] `environments/dev.tfvars` exists
- [ ] `environments/prod.tfvars` exists

**Status:** ⬜ Not Done | ✅ Done

---

## 🚀 Deployment Order

Services will deploy in this order automatically:

1. **VPC** → Network foundation
2. **Security Groups** → Firewall rules
3. **S3** → Storage bucket
4. **IAM** → Roles and policies
5. **EC2** → Virtual servers
6. **CloudWatch** → Monitoring
7. **Auto Scaling** → Scaling group
8. **ALB** → Load balancer
9. **CloudFront** → CDN
10. **Route53** → DNS (if domain configured)
11. **RDS** → Database
12. **Lambda** → Serverless function

**All services deploy together in one workflow run!**

---

## 🎯 Ready to Deploy?

### Final Checks:
- [ ] S3 backend bucket created
- [ ] OIDC provider configured
- [ ] IAM role created with policy
- [ ] GitHub secrets added
- [ ] Environment files configured
- [ ] All files in correct folders

---

## 🚀 Deploy Commands

### Option 1: Push to Branch
```bash
git add .
git commit -m "Ready for deployment"
git push origin dev
```

### Option 2: Manual Trigger
1. Go to GitHub → Actions
2. Select "Deploy AWS Infrastructure"
3. Click "Run workflow"
4. Choose environment: `dev`
5. Click "Run workflow"

---

## 📊 Expected Results

After successful deployment:
- ✅ VPC with 2 subnets created
- ✅ Security groups configured
- ✅ S3 bucket with website
- ✅ EC2 instances (if count > 0)
- ✅ Load balancer active
- ✅ CloudFront distribution
- ✅ All outputs displayed

**Deployment time:** ~10-15 minutes

---

## 🐛 Troubleshooting

**If deployment fails:**
1. Check GitHub Actions logs
2. Verify AWS credentials/role
3. Check S3 bucket name is unique
4. Verify AMI ID is valid for region
5. Check AWS service limits

---

## ✅ Post-Deployment

After successful deployment:
1. Check outputs in GitHub Actions summary
2. Access ALB URL to verify
3. Check CloudFront distribution
4. Verify S3 website is accessible
5. Monitor CloudWatch for any issues

---

**Ready to deploy!** 🎉

# 🔐 IAM Policies

IAM policy documents for AWS permissions.

## 📄 Policies

### **github-actions-policy.json**
IAM policy for GitHub Actions OIDC role

**Permissions:**
- EC2, VPC, ELB
- Auto Scaling
- S3, CloudFront
- Route53, IAM
- CloudWatch, SNS
- RDS, Lambda

**Usage:**
1. IAM Console → Policies → Create policy
2. JSON tab → Paste policy
3. Name: `GitHubActionsTerraformPolicy`
4. Attach to role: `AWS-TERRAFORM-ALL-SERVICES`

---

## 🎯 Purpose

Provides least-privilege access for GitHub Actions to deploy infrastructure.

# Deployment Guide - Step by Step

## 🚀 Complete Deployment Instructions

This guide walks you through deploying the entire infrastructure from scratch.

---

## 📋 Prerequisites Checklist

### **Required**
- [ ] AWS Account (with billing enabled)
- [ ] Terraform installed (v1.0 or higher)
- [ ] AWS CLI installed and configured
- [ ] Text editor (VS Code, Notepad++, etc.)
- [ ] Terminal/Command Prompt access

### **Optional**
- [ ] Custom domain name
- [ ] Route 53 hosted zone
- [ ] ACM SSL certificate (for custom domain)
- [ ] Email address (for CloudWatch alerts)

---

## 🔧 Step 1: Install Prerequisites

### **Install Terraform**

**Windows:**
```bash
# Download from: https://www.terraform.io/downloads
# Extract to C:\terraform
# Add to PATH environment variable
terraform --version
```

**Mac:**
```bash
brew install terraform
terraform --version
```

**Linux:**
```bash
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

### **Install AWS CLI**

**Windows:**
```bash
# Download from: https://aws.amazon.com/cli/
# Run installer
aws --version
```

**Mac/Linux:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### **Configure AWS Credentials**

```bash
aws configure
```

Enter:
- AWS Access Key ID: [Your access key]
- AWS Secret Access Key: [Your secret key]
- Default region: us-east-1
- Default output format: json

---

## 📁 Step 2: Prepare Project Files

### **Navigate to Project Directory**

```bash
cd c:\Users\mahesh pilla\Desktop\ec-2\ec-2
```

### **Verify Files Exist**

```bash
dir  # Windows
ls   # Mac/Linux
```

You should see:
- main.tf
- variables.tf
- outputs.tf
- index.html
- modules/ folder

---

## ⚙️ Step 3: Customize Configuration (Optional)

### **Option A: Use Default Values**
Skip this step - uses defaults from variables.tf

### **Option B: Create terraform.tfvars**

Create file: `terraform.tfvars`

```hcl
# Basic Configuration
region         = "us-east-1"
instance_count = 1
instance_type  = "t3.micro"

# Networking
vpc_cidr            = "10.0.0.0/16"
subnet_cidr         = "10.0.1.0/24"
subnet_cidr_2       = "10.0.2.0/24"
availability_zone   = "us-east-1a"
availability_zone_2 = "us-east-1b"

# S3 Bucket (must be globally unique)
bucket_name = "my-unique-bucket-name-12345"

# CloudWatch Alerts (optional)
alarm_email = "your-email@example.com"

# Auto Scaling
asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 1

# Custom Domain (optional - leave empty if not using)
domain_name          = ""
hosted_zone_name     = ""
acm_certificate_arn  = ""
```

### **Important: Change Bucket Name**
S3 bucket names must be globally unique. Change:
```hcl
bucket_name = "service-code-bucket-lokesh-unique"
```
To something unique like:
```hcl
bucket_name = "my-company-website-2024-abc123"
```

---

## 🎬 Step 4: Initialize Terraform

### **Run Init Command**

```bash
terraform init
```

### **What Happens**
- Downloads AWS provider plugin
- Initializes backend
- Prepares modules
- Creates .terraform folder

### **Expected Output**
```
Initializing modules...
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v5.x.x...

Terraform has been successfully initialized!
```

### **Troubleshooting**
- **Error: No AWS credentials**: Run `aws configure`
- **Error: Module not found**: Check modules/ folder exists
- **Error: Provider not found**: Check internet connection

---

## 📊 Step 5: Review Execution Plan

### **Run Plan Command**

```bash
terraform plan
```

### **What Happens**
- Analyzes configuration
- Shows what will be created
- Estimates changes
- No actual changes made

### **Expected Output**
```
Plan: 16 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vpc_id
  + ec2_instance_ids
  + s3_bucket_name
  + alb_url
  + website_url
  ...
```

### **Review Carefully**
- Check resource counts
- Verify configurations
- Confirm costs
- Look for errors

### **Common Issues**

**Issue: CloudFront Access Denied**
```
Error: Your account must be verified before you can add new CloudFront resources.
```
**Solution**: Contact AWS Support to verify account

**Issue: vCPU Limit Exceeded**
```
Error: You have requested more vCPU capacity than your current vCPU limit
```
**Solution**: Reduce instance_count to 0 or 1, or request limit increase

**Issue: Bucket Name Taken**
```
Error: BucketAlreadyExists
```
**Solution**: Change bucket_name to something unique

---

## 🚀 Step 6: Deploy Infrastructure

### **Run Apply Command**

```bash
terraform apply
```

### **Confirmation Prompt**
```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Type: `yes` and press Enter

### **Deployment Progress**

```
module.vpc.aws_vpc.main: Creating...
module.s3.aws_s3_bucket.service_bucket: Creating...
module.vpc.aws_vpc.main: Creation complete after 5s
module.security_group.aws_security_group.ec2_sg: Creating...
...
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
```

### **Deployment Time**
- VPC, Subnets: 1-2 minutes
- EC2 Instances: 2-3 minutes
- S3, IAM: 1 minute
- ALB: 2-3 minutes
- CloudFront: 5-10 minutes (longest)
- **Total: 10-15 minutes**

### **What Gets Created**
1. VPC and 2 Subnets
2. Internet Gateway
3. Route Tables
4. Security Group
5. S3 Bucket with website
6. IAM Role and Instance Profile
7. EC2 Instance(s)
8. CloudWatch Alarms
9. Auto Scaling Group
10. Application Load Balancer
11. CloudFront Distribution
12. Route 53 Records (if domain configured)

---

## 📤 Step 7: View Outputs

### **After Successful Deployment**

```
Outputs:

alb_dns_name = "ec2-load-balancer-123456789.us-east-1.elb.amazonaws.com"
alb_url = "http://ec2-load-balancer-123456789.us-east-1.elb.amazonaws.com"
autoscaling_group_name = "ec2-autoscaling-group"
cloudfront_distribution_id = "E1234ABCD5678"
cloudfront_domain_name = "d1234abcd5678.cloudfront.net"
cloudwatch_sns_topic = "arn:aws:sns:us-east-1:123456789012:ec2-alarms-topic"
ec2_instance_ids = [
  "i-0123456789abcdef0",
]
ec2_private_ips = [
  "10.0.1.45",
]
ec2_public_ips = [
  "54.123.45.67",
]
iam_role_arn = "arn:aws:iam::123456789012:role/ec2-s3-access-role"
s3_bucket_name = "service-code-bucket-lokesh-unique"
s3_website_endpoint = "service-code-bucket-lokesh-unique.s3-website-us-east-1.amazonaws.com"
security_group_id = "sg-0123456789abcdef0"
subnet_id = "subnet-0123456789abcdef0"
vpc_id = "vpc-0123456789abcdef0"
website_url = "https://d1234abcd5678.cloudfront.net"
```

### **Save These Values**
Copy outputs to a text file for reference.

---

## 🌐 Step 8: Access Your Website

### **Option 1: CloudFront URL (Recommended)**
```
https://d1234abcd5678.cloudfront.net
```
- HTTPS enabled
- Global CDN
- Fast loading
- Serves S3 content

### **Option 2: ALB URL**
```
http://ec2-load-balancer-123456789.us-east-1.elb.amazonaws.com
```
- HTTP only
- Direct to EC2 instances
- For application testing

### **Option 3: S3 Website URL**
```
http://service-code-bucket-lokesh-unique.s3-website-us-east-1.amazonaws.com
```
- HTTP only
- Direct S3 access
- No CDN

### **Option 4: Custom Domain (if configured)**
```
https://www.yourdomain.com
```
- Your domain name
- HTTPS enabled
- Professional

---

## ✅ Step 9: Verify Deployment

### **Check Website**
1. Open CloudFront URL in browser
2. Should see: "Hello from S3 + CloudFront + Route 53!"
3. Verify HTTPS lock icon

### **Check EC2 Instances**
```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=ec2-instance-*"
```

### **Check S3 Bucket**
```bash
aws s3 ls s3://service-code-bucket-lokesh-unique/
```
Should show: index.html

### **Check ALB Health**
```bash
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
```

### **Check CloudWatch Alarms**
```bash
aws cloudwatch describe-alarms
```

---

## 📧 Step 10: Confirm Email Subscription (if configured)

### **If you set alarm_email**

1. Check your email inbox
2. Look for: "AWS Notification - Subscription Confirmation"
3. Click "Confirm subscription" link
4. You'll receive alerts when CPU > 80%

---

## 🔄 Step 11: Test Auto Scaling (Optional)

### **Stress Test EC2**

SSH into EC2:
```bash
ssh -i your-key.pem ec2-user@<ec2-public-ip>
```

Install stress tool:
```bash
sudo yum install stress -y
```

Generate CPU load:
```bash
stress --cpu 2 --timeout 600
```

### **Watch Auto Scaling**

Monitor in AWS Console:
1. Go to EC2 → Auto Scaling Groups
2. Watch "Desired capacity" increase
3. New instance launches
4. ALB adds instance to target group

---

## 🛠️ Step 12: Make Changes (Optional)

### **Update Configuration**

Edit `terraform.tfvars`:
```hcl
instance_count = 2  # Change from 1 to 2
```

### **Apply Changes**

```bash
terraform plan   # Review changes
terraform apply  # Apply changes
```

### **What Happens**
- Terraform detects differences
- Shows what will change
- Creates additional resources
- Updates existing resources

---

## 🗑️ Step 13: Destroy Infrastructure (When Done)

### **⚠️ WARNING: This deletes everything!**

### **Run Destroy Command**

```bash
terraform destroy
```

### **Confirmation**
```
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```

Type: `yes` and press Enter

### **Destruction Progress**
```
module.route53.aws_route53_record.website[0]: Destroying...
module.cloudfront.aws_cloudfront_distribution.website_distribution: Destroying...
module.alb.aws_lb.main: Destroying...
module.ec2.aws_instance.ec2[0]: Destroying...
...
Destroy complete! Resources: 16 destroyed.
```

### **Destruction Time**
- CloudFront: 10-15 minutes (longest)
- ALB: 2-3 minutes
- EC2: 1-2 minutes
- Other resources: 1-2 minutes
- **Total: 15-20 minutes**

### **Verify Deletion**

Check AWS Console:
- EC2 → Instances (should be terminated)
- S3 → Buckets (should be deleted)
- VPC → Your VPCs (should be deleted)
- CloudFront → Distributions (should be disabled)

---

## 🐛 Troubleshooting Guide

### **Issue: Terraform Init Fails**

**Error**: "Failed to install provider"
**Solution**:
```bash
# Clear cache
rm -rf .terraform
rm .terraform.lock.hcl
terraform init
```

### **Issue: Apply Fails Midway**

**Error**: "Error creating resource"
**Solution**:
```bash
# Terraform saves state, safe to re-run
terraform apply
```

### **Issue: Can't Destroy Resources**

**Error**: "Resource still in use"
**Solution**:
```bash
# Force destroy S3 bucket
aws s3 rb s3://bucket-name --force

# Then retry
terraform destroy
```

### **Issue: CloudFront Takes Too Long**

**Status**: "Creating... [5m0s elapsed]"
**Solution**: This is normal. CloudFront takes 10-15 minutes. Be patient.

### **Issue: State Lock Error**

**Error**: "Error acquiring the state lock"
**Solution**:
```bash
# Force unlock (use carefully)
terraform force-unlock <lock-id>
```

---

## 📊 Cost Management

### **Monitor Costs**

AWS Console → Billing Dashboard

### **Set Budget Alerts**

1. Go to AWS Budgets
2. Create budget: $50/month
3. Set alert at 80% ($40)
4. Receive email notifications

### **Reduce Costs**

- Set `instance_count = 0` (no EC2)
- Use `t3.nano` instead of `t3.micro`
- Delete CloudFront distribution
- Use S3 website only

---

## ✅ Deployment Checklist

- [ ] Prerequisites installed
- [ ] AWS credentials configured
- [ ] Project files ready
- [ ] Bucket name customized
- [ ] terraform init successful
- [ ] terraform plan reviewed
- [ ] terraform apply completed
- [ ] Outputs saved
- [ ] Website accessible
- [ ] Email subscription confirmed
- [ ] Resources verified in AWS Console
- [ ] Documentation reviewed

---

## 🎓 Next Steps

1. **Customize Website**: Edit index.html
2. **Add SSL Certificate**: For custom domain
3. **Configure Monitoring**: Set up dashboards
4. **Implement CI/CD**: Automate deployments
5. **Add Database**: RDS for dynamic content
6. **Enable Logging**: CloudWatch Logs
7. **Set Up Backups**: AWS Backup service

---

## 📞 Getting Help

### **Terraform Issues**
- Documentation: https://www.terraform.io/docs
- Community: https://discuss.hashicorp.com

### **AWS Issues**
- AWS Support: https://console.aws.amazon.com/support
- Documentation: https://docs.aws.amazon.com

### **Project Issues**
- Review error messages carefully
- Check AWS service limits
- Verify credentials and permissions
- Consult documentation files

---

**End of Deployment Guide**

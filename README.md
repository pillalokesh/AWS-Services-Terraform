# AWS Infrastructure Project - Complete Documentation

## 📋 Project Overview

This project creates a **complete production-ready AWS infrastructure** using Terraform with modular architecture. It deploys a highly available web application with load balancing, auto-scaling, monitoring, and static website hosting.

---

## 🏗️ Architecture Overview

```
Internet
    ↓
CloudFront (CDN) → S3 (Static Website)
    ↓
Route 53 (DNS)
    ↓
Application Load Balancer
    ↓
EC2 Instances (Auto Scaling)
    ↓
CloudWatch (Monitoring)
```

---

## 📁 Project Structure

```
ec-2/
├── main.tf              # Main configuration file - orchestrates all modules
├── variables.tf         # Input variables with default values
├── outputs.tf           # Output values after deployment
├── index.html           # Static website HTML file
├── modules/             # Reusable infrastructure modules
│   ├── vpc/            # Virtual Private Cloud
│   ├── security-group/ # Firewall rules
│   ├── ec2/            # Virtual servers
│   ├── s3/             # Object storage
│   ├── iam/            # Identity and access management
│   ├── cloudfront/     # Content delivery network
│   ├── route53/        # DNS management
│   ├── alb/            # Application load balancer
│   ├── autoscaling/    # Auto scaling group
│   └── cloudwatch/     # Monitoring and alarms
└── docs/               # Documentation files
```

---

## 🎯 What This Project Does

### 1. **Networking Infrastructure**
- Creates isolated VPC with 2 public subnets in different availability zones
- Sets up Internet Gateway for public internet access
- Configures route tables for traffic routing

### 2. **Compute Resources**
- Deploys EC2 instances with IAM roles for secure S3 access
- Auto Scaling Group that scales from 1-3 instances based on demand
- Application Load Balancer distributes traffic across instances

### 3. **Storage & Content Delivery**
- S3 bucket for static website hosting
- CloudFront CDN for global content delivery with HTTPS
- Automatic upload of index.html to S3

### 4. **Security**
- IAM roles for EC2 to access S3 without credentials
- Security groups acting as virtual firewalls
- HTTPS encryption via CloudFront

### 5. **Monitoring & Alerts**
- CloudWatch alarms for CPU monitoring
- Email notifications when CPU exceeds 80%
- SNS topics for alert distribution

### 6. **DNS Management**
- Route 53 for custom domain configuration
- Automatic DNS record creation pointing to CloudFront

---

## 📄 Core Files Explanation

### **main.tf**
**Purpose**: Orchestrates all infrastructure modules
**What it does**:
- Defines AWS provider and region
- Calls all module blocks in correct dependency order
- Passes variables between modules
- Creates the complete infrastructure

**Key Sections**:
```hcl
provider "aws"           # AWS connection configuration
module "vpc"             # Network foundation
module "security_group"  # Firewall rules
module "s3"              # Storage bucket
module "iam"             # Access permissions
module "ec2"             # Virtual servers
module "cloudwatch"      # Monitoring
module "autoscaling"     # Auto scaling
module "alb"             # Load balancer
module "cloudfront"      # CDN
module "route53"         # DNS
```

---

### **variables.tf**
**Purpose**: Defines all configurable parameters
**What it does**:
- Declares input variables with descriptions
- Sets default values for all parameters
- Allows customization without changing code

**Key Variables**:
- `region`: AWS region (default: us-east-1)
- `vpc_cidr`: Network IP range (default: 10.0.0.0/16)
- `instance_type`: EC2 size (default: t3.micro)
- `instance_count`: Number of EC2 instances (default: 1)
- `bucket_name`: S3 bucket name (default: service-code-bucket-lokesh-unique)
- `alarm_email`: Email for alerts (default: empty)
- `asg_min_size`: Minimum instances (default: 1)
- `asg_max_size`: Maximum instances (default: 3)

---

### **outputs.tf**
**Purpose**: Displays important information after deployment
**What it does**:
- Shows VPC ID, subnet IDs
- Displays EC2 instance IDs and IP addresses
- Provides S3 bucket name and website endpoint
- Shows ALB DNS name and URL
- Displays CloudFront distribution details
- Shows website URLs for access

**Key Outputs**:
- `vpc_id`: VPC identifier
- `ec2_public_ips`: Public IP addresses of EC2 instances
- `s3_bucket_name`: S3 bucket name
- `alb_url`: Load balancer URL
- `cloudfront_domain_name`: CDN domain
- `website_url`: Final website URL

---

### **index.html**
**Purpose**: Static website content
**What it does**:
- Simple HTML page hosted on S3
- Served via CloudFront CDN
- Accessible through load balancer

---

## 🔧 How to Use This Project

### **Prerequisites**
1. AWS Account
2. Terraform installed (v1.0+)
3. AWS CLI configured with credentials

### **Deployment Steps**

**Step 1: Initialize Terraform**
```bash
cd ec-2/ec-2
terraform init
```
- Downloads AWS provider
- Initializes modules
- Prepares backend

**Step 2: Review Plan**
```bash
terraform plan
```
- Shows what will be created
- Validates configuration
- Estimates costs

**Step 3: Deploy Infrastructure**
```bash
terraform apply
```
- Creates all AWS resources
- Takes 5-10 minutes
- Prompts for confirmation

**Step 4: Access Your Website**
- ALB URL: Check `alb_url` output
- CloudFront URL: Check `website_url` output
- S3 URL: Check `s3_website_endpoint` output

**Step 5: Destroy Infrastructure (when done)**
```bash
terraform destroy
```
- Removes all resources
- Stops AWS charges

---

## 💰 Cost Estimation

**Monthly Costs (Approximate)**:
- VPC: Free
- EC2 (1x t3.micro): ~$7.50
- S3: ~$0.50
- CloudFront: ~$1.00
- ALB: ~$16.00
- Route 53: ~$0.50 (if using custom domain)
- **Total: ~$25-30/month**

---

## 🔐 Security Features

1. **IAM Roles**: No hardcoded credentials
2. **Security Groups**: Restricted access (ports 22, 80)
3. **HTTPS**: CloudFront provides SSL/TLS
4. **Private Subnets**: Can be added for databases
5. **Least Privilege**: IAM policies grant minimal permissions

---

## 📊 Monitoring & Alerts

- **CloudWatch Alarms**: Monitor CPU usage
- **Email Notifications**: Alerts when CPU > 80%
- **Health Checks**: ALB monitors instance health
- **Auto Scaling**: Automatically adds/removes instances

---

## 🚀 Advanced Features

### **Auto Scaling**
- Scales from 1 to 3 instances
- Based on CPU utilization
- 5-minute cooldown period

### **Load Balancing**
- Distributes traffic evenly
- Health checks every 30 seconds
- Removes unhealthy instances

### **High Availability**
- Multi-AZ deployment (us-east-1a, us-east-1b)
- Redundant subnets
- Automatic failover

---

## 📝 Customization Guide

### **Change Instance Type**
Edit `variables.tf`:
```hcl
variable "instance_type" {
  default = "t3.small"  # Change from t3.micro
}
```

### **Add Email Alerts**
Create `terraform.tfvars`:
```hcl
alarm_email = "your-email@example.com"
```

### **Scale More Instances**
Edit `variables.tf`:
```hcl
variable "asg_max_size" {
  default = 5  # Scale up to 5 instances
}
```

### **Use Custom Domain**
Create `terraform.tfvars`:
```hcl
domain_name = "www.yourdomain.com"
hosted_zone_name = "yourdomain.com"
acm_certificate_arn = "arn:aws:acm:us-east-1:xxx:certificate/xxx"
```

---

## 🐛 Troubleshooting

### **CloudFront Error**
- **Issue**: Account not verified
- **Solution**: Contact AWS Support to verify account

### **vCPU Limit Error**
- **Issue**: Exceeded EC2 limits
- **Solution**: Request limit increase or reduce instance_count

### **S3 Bucket Name Taken**
- **Issue**: Bucket name must be globally unique
- **Solution**: Change bucket_name in variables.tf

---

## 📚 Next Steps

1. Add RDS database for dynamic content
2. Implement CI/CD pipeline
3. Add WAF for security
4. Configure backup strategy
5. Set up logging with CloudWatch Logs

---

## 📞 Support

For issues or questions:
1. Check AWS documentation
2. Review Terraform logs
3. Verify AWS service limits
4. Check security group rules

---

**Created by**: Lokesh
**Last Updated**: 2024
**Terraform Version**: 1.0+
**AWS Provider Version**: Latest

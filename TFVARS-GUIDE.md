# Terraform Variables Guide (tfvars)

## 📋 What is terraform.tfvars?

**terraform.tfvars** is a file that contains actual values for your variables. It allows you to customize your infrastructure without modifying the main Terraform code.

---

## 📁 Files Created

### **1. terraform.tfvars** (Main Configuration)
- Default configuration file
- Automatically loaded by Terraform
- Contains all customizable values
- **Use this file** for your deployment

### **2. terraform.tfvars.dev.example** (Development)
- Minimal cost configuration
- No EC2 instances (S3 + CloudFront only)
- No custom domain
- Cost: ~$2-5/month

### **3. terraform.tfvars.staging.example** (Staging)
- Balanced configuration
- Single EC2 instance
- Optional custom domain
- Cost: ~$25-35/month

### **4. terraform.tfvars.prod.example** (Production)
- High availability configuration
- Multiple EC2 instances
- Custom domain required
- Cost: ~$50-80/month

---

## 🚀 How to Use

### **Option 1: Use Default terraform.tfvars**

1. **Edit terraform.tfvars**
```bash
notepad terraform.tfvars  # Windows
nano terraform.tfvars     # Linux/Mac
```

2. **Customize values**
```hcl
bucket_name = "my-unique-bucket-name-2024"
alarm_email = "your-email@example.com"
instance_count = 1
```

3. **Deploy**
```bash
terraform init
terraform plan
terraform apply
```

Terraform automatically loads `terraform.tfvars`

---

### **Option 2: Use Example Files**

1. **Copy example file**
```bash
# For Development
copy terraform.tfvars.dev.example terraform.tfvars

# For Staging
copy terraform.tfvars.staging.example terraform.tfvars

# For Production
copy terraform.tfvars.prod.example terraform.tfvars
```

2. **Edit copied file**
```bash
notepad terraform.tfvars
```

3. **Customize required values**
- Change bucket_name (must be unique)
- Add your email for alerts
- Adjust instance counts

4. **Deploy**
```bash
terraform apply
```

---

### **Option 3: Use Custom Named File**

1. **Create custom file**
```bash
# Create myconfig.tfvars
notepad myconfig.tfvars
```

2. **Add your values**
```hcl
region = "us-west-2"
bucket_name = "my-custom-bucket"
instance_count = 2
```

3. **Deploy with -var-file flag**
```bash
terraform apply -var-file="myconfig.tfvars"
```

---

### **Option 4: Override Individual Variables**

**Override via command line:**
```bash
terraform apply -var="instance_count=2" -var="bucket_name=my-bucket"
```

**Override via environment variables:**
```bash
# Windows
set TF_VAR_instance_count=2
set TF_VAR_bucket_name=my-bucket

# Linux/Mac
export TF_VAR_instance_count=2
export TF_VAR_bucket_name=my-bucket

terraform apply
```

---

## 📝 Variable Priority (Highest to Lowest)

1. **Command line** `-var` flags
2. **Environment variables** `TF_VAR_*`
3. **terraform.tfvars** (auto-loaded)
4. **terraform.tfvars.json** (auto-loaded)
5. ***.auto.tfvars** (auto-loaded)
6. **variables.tf** default values

---

## 🔧 Common Configurations

### **Minimal Cost Setup**
```hcl
# terraform.tfvars
region         = "us-east-1"
instance_count = 0  # No EC2
bucket_name    = "my-static-site-2024"
alarm_email    = ""
```
**Cost**: ~$2/month (S3 + CloudFront only)

---

### **Basic Website Setup**
```hcl
# terraform.tfvars
region         = "us-east-1"
instance_count = 1
instance_type  = "t3.micro"
bucket_name    = "my-website-2024"
alarm_email    = "admin@example.com"
```
**Cost**: ~$25/month

---

### **Production Setup**
```hcl
# terraform.tfvars
region               = "us-east-1"
instance_count       = 2
instance_type        = "t3.small"
bucket_name          = "mycompany-prod-2024"
alarm_email          = "ops@mycompany.com"
domain_name          = "www.mycompany.com"
hosted_zone_name     = "mycompany.com"
acm_certificate_arn  = "arn:aws:acm:us-east-1:xxx:certificate/xxx"
asg_min_size         = 2
asg_max_size         = 5
asg_desired_capacity = 2
```
**Cost**: ~$60/month

---

## ⚙️ Variable Descriptions

### **Required Variables**

| Variable | Description | Example |
|----------|-------------|---------|
| `bucket_name` | S3 bucket name (must be globally unique) | `"my-unique-bucket-2024"` |

### **Network Variables**

| Variable | Description | Default |
|----------|-------------|---------|
| `region` | AWS region | `"us-east-1"` |
| `vpc_cidr` | VPC IP range | `"10.0.0.0/16"` |
| `subnet_cidr` | First subnet range | `"10.0.1.0/24"` |
| `subnet_cidr_2` | Second subnet range | `"10.0.2.0/24"` |
| `availability_zone` | First AZ | `"us-east-1a"` |
| `availability_zone_2` | Second AZ | `"us-east-1b"` |

### **EC2 Variables**

| Variable | Description | Default |
|----------|-------------|---------|
| `ami_id` | Amazon Machine Image ID | `"ami-0c1fe732b5494dc14"` |
| `instance_type` | EC2 instance size | `"t3.micro"` |
| `instance_count` | Number of instances | `1` |

### **Monitoring Variables**

| Variable | Description | Default |
|----------|-------------|---------|
| `alarm_email` | Email for CloudWatch alerts | `""` (disabled) |

### **Auto Scaling Variables**

| Variable | Description | Default |
|----------|-------------|---------|
| `asg_min_size` | Minimum instances | `1` |
| `asg_max_size` | Maximum instances | `3` |
| `asg_desired_capacity` | Desired instances | `1` |

### **Domain Variables (Optional)**

| Variable | Description | Default |
|----------|-------------|---------|
| `domain_name` | Custom domain | `""` (disabled) |
| `hosted_zone_name` | Route 53 zone | `""` |
| `acm_certificate_arn` | SSL certificate ARN | `""` |

---

## ✅ Validation Checklist

Before deploying, verify:

- [ ] `bucket_name` is globally unique
- [ ] `bucket_name` follows naming rules (lowercase, no special chars)
- [ ] `alarm_email` is valid (if provided)
- [ ] `ami_id` matches your region
- [ ] `instance_count` is within AWS limits
- [ ] `domain_name` matches your Route 53 zone (if using)
- [ ] `acm_certificate_arn` is in us-east-1 (if using)

---

## 🐛 Common Issues

### **Issue: Bucket name already exists**
```
Error: BucketAlreadyExists
```
**Solution**: Change `bucket_name` to something unique

---

### **Issue: Invalid AMI**
```
Error: InvalidAMIID.NotFound
```
**Solution**: Use correct AMI for your region
- Find AMIs: https://console.aws.amazon.com/ec2/

---

### **Issue: vCPU limit exceeded**
```
Error: VcpuLimitExceeded
```
**Solution**: 
- Reduce `instance_count`
- Request limit increase from AWS

---

### **Issue: Email not confirmed**
```
CloudWatch alarms created but no emails received
```
**Solution**: Check email and click "Confirm subscription"

---

## 📊 Cost Estimation by Configuration

### **Development (Minimal)**
```hcl
instance_count = 0
```
- S3: $0.50
- CloudFront: $1.00
- **Total: ~$2/month**

### **Staging (Basic)**
```hcl
instance_count = 1
instance_type = "t3.micro"
```
- EC2: $7.50
- ALB: $16.00
- S3: $0.50
- CloudFront: $1.00
- **Total: ~$25/month**

### **Production (High Availability)**
```hcl
instance_count = 2
instance_type = "t3.small"
asg_max_size = 5
```
- EC2: $30.00
- ALB: $16.00
- S3: $1.00
- CloudFront: $2.00
- Route 53: $1.00
- **Total: ~$50-80/month**

---

## 🔐 Security Best Practices

### **DO:**
- ✅ Use unique bucket names
- ✅ Enable email alerts
- ✅ Use HTTPS (CloudFront)
- ✅ Keep tfvars in .gitignore
- ✅ Use different configs for dev/staging/prod

### **DON'T:**
- ❌ Commit secrets to Git
- ❌ Use default passwords
- ❌ Share tfvars files publicly
- ❌ Use same config for all environments

---

## 📚 Examples

### **Example 1: Personal Blog**
```hcl
region         = "us-east-1"
instance_count = 0
bucket_name    = "myblog-static-site-2024"
alarm_email    = ""
```

### **Example 2: Small Business Website**
```hcl
region         = "us-east-1"
instance_count = 1
instance_type  = "t3.micro"
bucket_name    = "mycompany-website-2024"
alarm_email    = "admin@mycompany.com"
domain_name    = "www.mycompany.com"
```

### **Example 3: E-commerce Site**
```hcl
region               = "us-east-1"
instance_count       = 3
instance_type        = "t3.medium"
bucket_name          = "mystore-prod-2024"
alarm_email          = "ops@mystore.com"
domain_name          = "www.mystore.com"
asg_min_size         = 3
asg_max_size         = 10
asg_desired_capacity = 5
```

---

## 🚀 Quick Start

1. **Copy main tfvars file**
```bash
# File already exists: terraform.tfvars
```

2. **Edit required values**
```bash
notepad terraform.tfvars
```

3. **Change bucket name** (REQUIRED)
```hcl
bucket_name = "your-unique-bucket-name-2024"
```

4. **Add email** (optional)
```hcl
alarm_email = "your-email@example.com"
```

5. **Deploy**
```bash
terraform init
terraform apply
```

---

## 📞 Need Help?

- Check variable descriptions in `variables.tf`
- Review example files (*.example)
- Read DEPLOYMENT.md for detailed guide
- Consult AWS documentation

---

**Your terraform.tfvars file is ready to use!** 🎉

Just customize the values and run `terraform apply`

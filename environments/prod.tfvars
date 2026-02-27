# ============================================================================
# Example: Production Environment Configuration
# ============================================================================
# Use this for production with high availability and custom domain
# Copy to terraform.tfvars to use
# ============================================================================

# AWS Region
region = "us-east-1"

# Network Configuration
vpc_cidr            = "10.0.0.0/16"
vpc_name            = "prod-vpc"
subnet_cidr         = "10.0.1.0/24"
subnet_cidr_2       = "10.0.2.0/24"
subnet_name         = "prod-subnet"
availability_zone   = "us-east-1a"
availability_zone_2 = "us-east-1b"

# Security Group
sg_name        = "prod-security-group"
sg_description = "Security group for production environment"

# EC2 Configuration - Production
ami_id         = "ami-0c1fe732b5494dc14"
instance_type  = "t3.small"  # Better performance
instance_count = 2           # Multiple instances for HA
instance_name  = "prod-instance"

# S3 Bucket - Production
bucket_name = "mycompany-prod-website-2024"

# Monitoring - Enabled with email alerts
alarm_email = "ops-team@mycompany.com"

# Auto Scaling - Production settings
asg_min_size         = 2  # Always 2 instances minimum
asg_max_size         = 5  # Scale up to 5 during peak
asg_desired_capacity = 2  # Start with 2 instances

# Custom Domain - Production domain
domain_name          = "www.mycompany.com"
hosted_zone_name     = "mycompany.com"
acm_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxx-xxxxx-xxxxx"

# ============================================================================
# Estimated Monthly Cost: $50-80
# - EC2 (2x t3.small): $30
# - ALB: $16
# - S3: $1
# - CloudFront: $2
# - Route 53: $1
# - Auto Scaling: Variable
# ============================================================================

# ============================================================================
# Prerequisites for Production:
# ============================================================================
# 1. Route 53 Hosted Zone created
# 2. ACM Certificate issued in us-east-1
# 3. Domain verified
# 4. Email confirmed for CloudWatch alerts
# 5. AWS account limits increased if needed
# ============================================================================

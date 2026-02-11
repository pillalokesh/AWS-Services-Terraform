# ============================================================================
# Example: Staging Environment Configuration
# ============================================================================
# Use this for staging/testing before production
# Copy to terraform.tfvars to use
# ============================================================================

# AWS Region
region = "us-east-1"

# Network Configuration
vpc_cidr            = "10.0.0.0/16"
vpc_name            = "staging-vpc"
subnet_cidr         = "10.0.1.0/24"
subnet_cidr_2       = "10.0.2.0/24"
subnet_name         = "staging-subnet"
availability_zone   = "us-east-1a"
availability_zone_2 = "us-east-1b"

# Security Group
sg_name        = "staging-security-group"
sg_description = "Security group for staging environment"

# EC2 Configuration - Staging
ami_id         = "ami-0c1fe732b5494dc14"
instance_type  = "t3.micro"  # Balanced cost/performance
instance_count = 1           # Single instance
instance_name  = "staging-instance"

# S3 Bucket - Staging
bucket_name = "mycompany-staging-website-2024"

# Monitoring - Enabled
alarm_email = "dev-team@mycompany.com"

# Auto Scaling - Moderate
asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 1

# Custom Domain - Staging subdomain
domain_name          = "staging.mycompany.com"
hosted_zone_name     = "mycompany.com"
acm_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxx-xxxxx-xxxxx"

# ============================================================================
# Estimated Monthly Cost: $25-35
# - EC2 (1x t3.micro): $7.50
# - ALB: $16
# - S3: $0.50
# - CloudFront: $1
# - Route 53: $0.50
# ============================================================================

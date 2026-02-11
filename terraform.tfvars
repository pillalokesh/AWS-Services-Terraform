# ============================================================================
# Terraform Variables Configuration File
# ============================================================================
# ALL values are stored here. No defaults in variables.tf
# Modify these values according to your requirements.
# ============================================================================

# ----------------------------------------------------------------------------
# AWS Region Configuration
# ----------------------------------------------------------------------------
region = "us-east-1"

# ----------------------------------------------------------------------------
# VPC Network Configuration
# ----------------------------------------------------------------------------
vpc_cidr            = "10.0.0.0/16"
vpc_name            = "main-vpc"
subnet_cidr         = "10.0.1.0/24"
subnet_cidr_2       = "10.0.2.0/24"
subnet_name         = "public-subnet"
availability_zone   = "us-east-1a"
availability_zone_2 = "us-east-1b"

# ----------------------------------------------------------------------------
# Security Group Configuration
# ----------------------------------------------------------------------------
sg_name        = "ec2-security-group"
sg_description = "Security group for EC2 instances"

# ----------------------------------------------------------------------------
# EC2 Instance Configuration
# ----------------------------------------------------------------------------
ami_id         = "ami-0c1fe732b5494dc14"  # Amazon Linux 2023 (us-east-1)
instance_type  = "t3.micro"                # 2 vCPU, 1GB RAM
instance_count = 1                         # Number of EC2 instances
instance_name  = "ec2-instance"            # Base name for instances

# ----------------------------------------------------------------------------
# S3 Bucket Configuration
# ----------------------------------------------------------------------------
# IMPORTANT: Bucket name must be globally unique across all AWS accounts
bucket_name = "service-code-bucket-lokesh-unique-2024"

# ----------------------------------------------------------------------------
# CloudWatch Monitoring Configuration
# ----------------------------------------------------------------------------
# Email address to receive CloudWatch alarms
# Leave empty ("") to disable email notifications
alarm_email = ""

# ----------------------------------------------------------------------------
# Auto Scaling Group Configuration
# ----------------------------------------------------------------------------
asg_min_size         = 1  # Minimum number of instances
asg_max_size         = 3  # Maximum number of instances
asg_desired_capacity = 1  # Desired number of instances

# ----------------------------------------------------------------------------
# Custom Domain Configuration (Optional)
# ----------------------------------------------------------------------------
# Leave empty ("") if you don't have a custom domain
domain_name          = ""
hosted_zone_name     = ""
acm_certificate_arn  = ""

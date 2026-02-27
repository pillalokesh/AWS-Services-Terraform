# AWS Region
region = "us-east-1"

# Network Configuration
vpc_cidr            = "10.0.0.0/16"
vpc_name            = "dev-vpc"
subnet_cidr         = "10.0.1.0/24"
subnet_cidr_2       = "10.0.2.0/24"
subnet_name         = "dev-subnet"
availability_zone   = "us-east-1a"
availability_zone_2 = "us-east-1b"

# Security Group
sg_name        = "dev-security-group"
sg_description = "Security group for development environment"

# EC2 Configuration
ami_id         = "ami-0c1fe732b5494dc14"
instance_type  = "t3.micro"
instance_count = 1
instance_name  = "dev-instance"

# S3 Bucket
bucket_name = "mycompany-dev-website-2024"

# Monitoring
alarm_email = ""

# Auto Scaling
asg_min_size         = 1
asg_max_size         = 2
asg_desired_capacity = 1

# Custom Domain
domain_name         = ""
hosted_zone_name    = ""
acm_certificate_arn = ""

# RDS Database
db_name             = "devdb"
db_username         = "admin"
db_password         = "changeme123"
db_engine           = "mysql"
db_engine_version   = "8.0"
db_instance_class   = "db.t3.micro"
db_allocated_storage = 20
db_multi_az         = false

# Lambda Function
lambda_function_name = "dev-lambda-function"
lambda_runtime       = "python3.9"
lambda_handler       = "lambda_function.lambda_handler"
lambda_timeout       = 30
lambda_memory_size   = 128

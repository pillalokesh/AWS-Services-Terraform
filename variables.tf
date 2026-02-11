variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "main-vpc"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "public-subnet"
}

variable "availability_zone" {
  description = "Availability zone"
  default     = "us-east-1a"
}

variable "subnet_cidr_2" {
  description = "CIDR block for second subnet"
  default     = "10.0.2.0/24"
}

variable "availability_zone_2" {
  description = "Availability zone for second subnet"
  default     = "us-east-1b"
}

variable "sg_name" {
  description = "Security group name"
  default     = "ec2-security-group"
}

variable "sg_description" {
  description = "Security group description"
  default     = "Security group for EC2 instances"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0c1fe732b5494dc14"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  default     = 1
}

variable "instance_name" {
  description = "Base name for EC2 instances"
  default     = "ec2-instance"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  default     = "service-code-bucket-lokesh-unique"
}

variable "domain_name" {
  description = "Custom domain name for the website (leave empty to use CloudFront domain)"
  default     = ""
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name (e.g., example.com)"
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate in us-east-1 for custom domain"
  default     = ""
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarms"
  default     = ""
}

variable "asg_min_size" {
  description = "Minimum size of Auto Scaling Group"
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum size of Auto Scaling Group"
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired capacity of Auto Scaling Group"
  default     = 1
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

variable "subnet_cidr_2" {
  description = "CIDR block for second subnet"
  type        = string
}

variable "availability_zone_2" {
  description = "Availability zone for second subnet"
  type        = string
}

variable "sg_name" {
  description = "Security group name"
  type        = string
}

variable "sg_description" {
  description = "Security group description"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
}

variable "instance_name" {
  description = "Base name for EC2 instances"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for the website (leave empty to use CloudFront domain)"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route53 hosted zone name (e.g., example.com)"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate in us-east-1 for custom domain"
  type        = string
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarms"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum size of Auto Scaling Group"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum size of Auto Scaling Group"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired capacity of Auto Scaling Group"
  type        = number
}

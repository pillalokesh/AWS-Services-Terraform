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
  default     = 3
}

variable "instance_name" {
  description = "Base name for EC2 instances"
  default     = "ec2-instance"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  default     = "service-code-bucket-lokesh-unique"
}

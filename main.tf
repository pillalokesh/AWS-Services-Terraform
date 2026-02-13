provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  subnet_cidr         = var.subnet_cidr
  subnet_name         = var.subnet_name
  availability_zone   = var.availability_zone
  subnet_cidr_2       = var.subnet_cidr_2
  availability_zone_2 = var.availability_zone_2
}

module "security_group" {
  source         = "./modules/security-group"
  vpc_id         = module.vpc.vpc_id
  sg_name        = var.sg_name
  sg_description = var.sg_description
}

module "s3" {
  source          = "./modules/s3"
  bucket_name     = var.bucket_name
  index_html_path = "${path.module}/index.html"
}

module "iam" {
  source     = "./modules/iam"
  role_name  = "ec2-s3-access-role"
  bucket_arn = module.s3.bucket_arn
}

module "ec2" {
  source               = "./modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  subnet_id            = module.vpc.subnet_id
  security_group_ids   = [module.security_group.security_group_id]
  instance_name        = var.instance_name
  iam_instance_profile = module.iam.instance_profile_name
}

module "cloudwatch" {
  source       = "./modules/cloudwatch"
  instance_ids = module.ec2.instance_ids
  alarm_email  = var.alarm_email
}

module "autoscaling" {
  source                = "./modules/autoscaling"
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  security_group_ids    = [module.security_group.security_group_id]
  subnet_id             = module.vpc.subnet_id
  min_size              = var.asg_min_size
  max_size              = var.asg_max_size
  desired_capacity      = var.asg_desired_capacity
  instance_profile_name = module.iam.instance_profile_name
}

module "alb" {
  source             = "./modules/alb"
  alb_name           = "ec2-load-balancer"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = [module.security_group.security_group_id]
  instance_ids       = module.ec2.instance_ids
}

module "cloudfront" {
  source                      = "./modules/cloudfront"
  bucket_name                 = var.bucket_name
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  domain_name                 = var.domain_name
  acm_certificate_arn         = var.acm_certificate_arn
}

module "route53" {
  source                    = "./modules/route53"
  domain_name               = var.domain_name
  hosted_zone_name          = var.hosted_zone_name
  cloudfront_domain_name    = module.cloudfront.distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.distribution_hosted_zone_id
}

module "rds" {
  source                   = "./modules/rds"
  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = var.db_password
  engine                   = var.db_engine
  engine_version           = var.db_engine_version
  instance_class           = var.db_instance_class
  allocated_storage        = var.db_allocated_storage
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.subnet_ids
  allowed_security_groups  = [module.security_group.security_group_id]
  skip_final_snapshot      = true
  multi_az                 = var.db_multi_az
}

module "lambda" {
  source                = "./modules/lambda"
  function_name         = var.lambda_function_name
  runtime               = var.lambda_runtime
  handler               = var.lambda_handler
  source_file           = "${path.module}/lambda_function.py"
  timeout               = var.lambda_timeout
  memory_size           = var.lambda_memory_size
  subnet_ids            = module.vpc.subnet_ids
  security_group_ids    = [module.security_group.security_group_id]
  environment_variables = {
    DB_ENDPOINT = module.rds.db_endpoint
    DB_NAME     = module.rds.db_name
    BUCKET_NAME = module.s3.bucket_id
  }
}

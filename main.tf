provider "aws" {
  region = var.region
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc_cidr
  vpc_name          = var.vpc_name
  subnet_cidr       = var.subnet_cidr
  subnet_name       = var.subnet_name
  availability_zone = var.availability_zone
}

module "security_group" {
  source         = "./modules/security-group"
  vpc_id         = module.vpc.vpc_id
  sg_name        = var.sg_name
  sg_description = var.sg_description
}

module "ec2" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  instance_count     = var.instance_count
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security_group.security_group_id]
  instance_name      = var.instance_name
}

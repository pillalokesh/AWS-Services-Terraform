output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "ec2_instance_ids" {
  value = module.ec2.instance_ids
}

output "ec2_public_ips" {
  value = module.ec2.public_ips
}

output "ec2_private_ips" {
  value = module.ec2.private_ips
}

output "s3_bucket_name" {
  value = module.s3.bucket_id
}

output "s3_website_endpoint" {
  value = module.s3.website_endpoint
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  value = module.cloudfront.distribution_domain_name
}

output "website_url" {
  value = var.domain_name != "" ? "https://${var.domain_name}" : "https://${module.cloudfront.distribution_domain_name}"
}

output "iam_role_arn" {
  value = module.iam.role_arn
}

output "autoscaling_group_name" {
  value = module.autoscaling.autoscaling_group_name
}

output "cloudwatch_sns_topic" {
  value = module.cloudwatch.sns_topic_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_url" {
  value = "http://${module.alb.alb_dns_name}"
}

output "rds_endpoint" {
  value       = module.rds.db_endpoint
  description = "RDS database endpoint"
}

output "rds_database_name" {
  value       = module.rds.db_name
  description = "RDS database name"
}

output "lambda_function_name" {
  value       = module.lambda.function_name
  description = "Lambda function name"
}

output "lambda_function_arn" {
  value       = module.lambda.function_arn
  description = "Lambda function ARN"
}

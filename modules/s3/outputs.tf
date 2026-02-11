output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.service_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.service_bucket.arn
}

output "website_endpoint" {
  description = "The website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "bucket_regional_domain_name" {
  description = "The bucket regional domain name"
  value       = aws_s3_bucket.service_bucket.bucket_regional_domain_name
}

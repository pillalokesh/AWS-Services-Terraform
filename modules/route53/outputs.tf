output "record_name" {
  description = "The name of the Route53 record"
  value       = var.domain_name != "" ? aws_route53_record.website[0].name : ""
}

output "record_fqdn" {
  description = "The FQDN of the Route53 record"
  value       = var.domain_name != "" ? aws_route53_record.website[0].fqdn : ""
}

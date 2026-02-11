data "aws_route53_zone" "main" {
  count = var.domain_name != "" ? 1 : 0
  name  = var.hosted_zone_name
}

resource "aws_route53_record" "website" {
  count   = var.domain_name != "" ? 1 : 0
  zone_id = data.aws_route53_zone.main[0].zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

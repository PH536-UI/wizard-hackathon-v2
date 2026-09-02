# CloudFront's own default certificate (*.cloudfront.net) is free and needs
# no ACM resource at all - this only matters if you attach a real domain.
# Skipped entirely when domain_name is empty (e.g. testing on Floci, or a
# quick hackathon demo without a purchased domain).

resource "aws_acm_certificate" "cdn" {
  count             = var.domain_name != "" ? 1 : 0
  provider          = aws.us_east_1 # ACM certs for CloudFront MUST be in us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.domain_name != "" ? {
    for dvo in aws_acm_certificate.cdn[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cdn" {
  count                   = var.domain_name != "" ? 1 : 0
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cdn[0].arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

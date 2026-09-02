locals {
  # aws_apigatewayv2_api.api_endpoint looks like
  # "https://{api-id}.execute-api.{region}.amazonaws.com" - CloudFront needs
  # just the bare hostname.
  api_origin_domain = replace(aws_apigatewayv2_api.app.api_endpoint, "https://", "")
}

resource "aws_cloudfront_distribution" "app" {
  # Confirmed on Floci: the AWS provider's CloudFront read-back panics
  # (nil pointer dereference) after create - Floci's response shape is
  # incomplete/malformed. Real-AWS-only, same pattern as Budgets/FIS.
  count           = var.use_local_emulator ? 0 : 1
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.project_name} - resilient edge distribution"
  price_class     = "PriceClass_100" # cheapest tier: NA + EU edge locations only, fine for a hackathon demo
  web_acl_id      = aws_wafv2_web_acl.ddos_mitigation.arn

  aliases = var.domain_name != "" ? [var.domain_name] : []

  origin {
    domain_name = local.api_origin_domain
    origin_id   = "api-gateway"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "api-gateway"
    viewer_protocol_policy = "redirect-to-https"

    # API responses are dynamic - do not cache by default
    forwarded_values {
      query_string = true
      headers      = ["Authorization"]
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.domain_name == "" ? true : null
    acm_certificate_arn            = var.domain_name != "" ? aws_acm_certificate_validation.cdn[0].certificate_arn : null
    ssl_support_method             = var.domain_name != "" ? "sni-only" : null
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = { Name = "${var.project_name}-cdn" }
}

resource "aws_route53_record" "cdn_alias" {
  count   = var.domain_name != "" && !var.use_local_emulator ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.app[0].domain_name
    zone_id                = aws_cloudfront_distribution.app[0].hosted_zone_id
    evaluate_target_health = false
  }
}

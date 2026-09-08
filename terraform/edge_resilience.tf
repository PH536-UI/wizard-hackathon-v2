resource "aws_s3_bucket" "primary" {
  bucket        = "wizard-site-primary-sa-east-1-536"
  force_destroy = true
  tags          = { Project = "WizardResilience2026" }
}

resource "aws_s3_bucket_public_access_block" "primary" {
  bucket                  = aws_s3_bucket.primary.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "dr" {
  bucket        = "wizard-site-dr-us-east-1-536"
  force_destroy = true
  tags          = { Project = "WizardResilience2026" }
}

resource "aws_s3_bucket_public_access_block" "dr" {
  bucket                  = aws_s3_bucket.dr.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "Wizard-OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_wafv2_web_acl" "api_waf" {
  name  = "wizard-api-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WizardApiWaf"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "RateLimit100"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitApi"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Project = "WizardResilience2026"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.ddos_mitigation.arn

  origin {
    domain_name              = aws_s3_bucket.primary.bucket_regional_domain_name
    origin_id                = "PrimaryS3"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  origin {
    domain_name              = aws_s3_bucket.dr.bucket_regional_domain_name
    origin_id                = "DRS3"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  origin_group {
    origin_id = "S3FailoverGroup"

    failover_criteria {
      status_codes = [500, 502, 503, 504]
    }

    member {
      origin_id = "PrimaryS3"
    }

    member {
      origin_id = "DRS3"
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3FailoverGroup"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/maintenance.html"
    error_caching_min_ttl = 5
  }

  custom_error_response {
    error_code            = 500
    response_code         = 200
    response_page_path    = "/maintenance.html"
    error_caching_min_ttl = 5
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project = "WizardResilience2026"
  }
}

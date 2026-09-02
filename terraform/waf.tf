resource "aws_wafv2_web_acl" "ddos_mitigation" {
  provider    = aws.us_east_1
  name        = "${var.project_name}-ddos-mitigation"
  description = "Blocks any single IP exceeding 100 requests per 5 minutes"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "DDoSMitigationRateLimit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit                 = 100
        evaluation_window_sec = 300
        aggregate_key_type    = "IP"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "DDoSMitigationMetric"
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-web-acl"
  }
}

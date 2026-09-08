resource "aws_cloudwatch_metric_alarm" "waf_block_rate_limit" {
  provider            = aws.us_east_1
  alarm_name          = "waf-block-rate-limit"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "WAF bloqueando - possivel ataque"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = {
    Rule   = "ALL"
    WebACL = "wizard-ddos-mitigation"
    Region = "Global"
  }
}

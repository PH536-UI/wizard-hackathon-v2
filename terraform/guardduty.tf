# GuardDuty was completely absent from the old architecture (WAF only
# blocks known bad patterns; GuardDuty detects anomalous behavior - e.g.
# credential compromise, reconnaissance, crypto-mining - that a static WAF
# rule would never catch). This satisfies the detection half of "blindagem
# e failover" that the doc asks for; WAF covers the blocking half.

resource "aws_guardduty_detector" "main" {
  enable = true
  tags   = { Name = "${var.project_name}-guardduty" }
}

# S3 data event monitoring, as a separate feature resource - the inline
# `datasources` block on aws_guardduty_detector is deprecated.
resource "aws_guardduty_detector_feature" "s3_logs" {
  detector_id = aws_guardduty_detector.main.id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}

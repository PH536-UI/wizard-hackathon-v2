resource "aws_sns_topic" "budget_alerts" {
  name = "wizard-budget-alerts"
  tags = {
    Project = "wizard"
    Event   = "WizardCloudHackathon2026"
    Team    = "Time-02"
  }
}

resource "aws_sns_topic_subscription" "budget_email" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = "team02@example.com"
}

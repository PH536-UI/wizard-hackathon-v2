resource "aws_budgets_budget" "event_cap" {
  name = "wizard-event-budget"
  budget_type = "COST"
  limit_amount = "10"
  limit_unit = "USD"
  time_unit = "DAILY"
  time_period_start = "2026-09-01_00:00"
  notification {
    comparison_operator = "GREATER_THAN"
    threshold = 80
    threshold_type = "PERCENTAGE"
    notification_type = "ACTUAL"
    subscriber_email_addresses = ["team02@example.com"]
  }
}
resource "aws_sns_topic" "budget_alerts" { name = "wizard-budget-alerts" }
resource "aws_sns_topic_subscription" "budget_email" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol = "email"
  endpoint = "team02@example.com"
}

resource "aws_sns_topic" "alerts" {
  name = "wizard-team-security-alerts"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  for_each = toset([
    "paulohenrique2020pereira@gmail.com",
    "priscilla.correa151091@gmail.com",
    "rndo.negocio@gmail.com",
    "thamara_catharine@hotmail.com",
    "vagnertomaz@hotmail.com"
  ])

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

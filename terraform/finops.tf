resource "aws_ce_anomaly_monitor" "service_monitor" {
  name              = "wizard-service-anomaly"
  monitor_type      = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "team_alerts" {
  name             = "wizard-anomaly-alerts"
  frequency        = "DAILY"
  monitor_arn_list = [aws_ce_anomaly_monitor.service_monitor.arn]

  subscriber {
    type    = "EMAIL"
    address = "vagnertomaz@hotmail.com"
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      values        = ["100"]
      match_options = ["GREATER_THAN_OR_EQUAL"]
    }
  }
}

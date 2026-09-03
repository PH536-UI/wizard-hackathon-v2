resource "aws_budgets_budget" "hackathon" {
  name         = "WizardResilience2026-Budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["ph@wizard.local"]
  }

  tags = {
    Environment = "Production"
    Team        = "Codex"
    Project     = "WizardResilience2026"
  }
}

resource "aws_dynamodb_table" "tfstate_locks" {
  name         = "wizard-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

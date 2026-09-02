# Replaces RDS Multi-AZ from the old architecture. DynamoDB is inherently
# multi-AZ within a region (AWS replicates every table across 3 AZs by
# default, no "multi_az = true" flag needed - it's just how the service
# works), which is actually a STRONGER story for the pitch than RDS failover:
# there's no failover event to demo because there's no single primary to fail.

resource "aws_dynamodb_table" "app_data" {
  name         = "${var.project_name}-app-data"
  billing_mode = "PAY_PER_REQUEST" # no capacity planning needed for a hackathon-scale demo
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = { Name = "${var.project_name}-app-data" }
}

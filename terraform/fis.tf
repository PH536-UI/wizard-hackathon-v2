resource "aws_iam_role" "fis" {
  name = "Wizard-FIS-Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "fis.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
  tags = { Project = "WizardResilience2026" }
}

resource "aws_iam_role_policy" "fis_s3" {
  name = "Wizard-FIS-S3"
  role = aws_iam_role.fis.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{ Effect = "Allow", Action = ["s3:DeleteObject", "s3:ListBucket"], Resource = ["arn:aws:s3:::wizard-site-primary-sa-east-1-536", "arn:aws:s3:::wizard-site-primary-sa-east-1-536/*"] }]
  })
}

resource "aws_fis_experiment_template" "break_primary" {
  description = "Wizard GameDay - Derruba Primary S3 pra testar failover"
  role_arn    = aws_iam_role.fis.arn
  tags        = { Project = "WizardResilience2026" }

  action {
    name      = "delete-primary-index"
    action_id = "aws:s3:delete-object"
    target {
      key   = "Buckets"
      value = "PrimaryBucket"
    }
    parameter {
      key   = "bucketName"
      value = "wizard-site-primary-sa-east-1-536"
    }
    parameter {
      key   = "objectKeys"
      value = "index.html"
    }
  }

  target {
    name           = "PrimaryBucket"
    resource_type  = "aws:s3:bucket"
    resource_arns  = ["arn:aws:s3:::wizard-site-primary-sa-east-1-536"]
    selection_mode = "ALL"
  }

  stop_condition {
    source = "none"
  }
}

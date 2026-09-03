# This is the piece that most changes the Game Day story vs. the old
# ALB+RDS architecture. There's no single primary DB/instance to fail over
# anymore - Lambda and DynamoDB are inherently spread across AZs by AWS,
# with no user-facing "promote standby" step. So the live proof isn't
# "watch a failover happen" anymore, it's "inject partial failure into the
# compute tier and show the site keeps serving most requests because there
# is no single point of failure to take the whole thing down."
#
# NOTE: double-check the exact action_id/parameter names against the current
# AWS FIS docs before the live demo - the Lambda fault-injection actions
# (aws:lambda:invocation-error, aws:lambda:invocation-add-delay) are newer
# additions to FIS and their parameter names have shifted between AWS
# announcements. Run `aws fis list-actions` against real AWS to confirm.

data "aws_iam_policy_document" "fis_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["fis.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fis_role" {
  name               = "${var.project_name}-fis-role"
  assume_role_policy = data.aws_iam_policy_document.fis_assume.json
}

resource "aws_iam_role_policy_attachment" "fis_lambda_access" {
  # Confirmed on Floci: this AWS managed policy doesn't exist locally.
  count      = var.use_local_emulator ? 0 : 1
  role       = aws_iam_role.fis_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorLambdaAccess"
}

resource "aws_fis_experiment_template" "lambda_partial_failure" {
  # Confirmed on Floci: UnknownOperationException. FIS is real-AWS-only,
  # same as Budgets - not implemented in the free local emulator.
  count       = var.use_local_emulator ? 0 : 1
  description = "Game Day: inject invocation errors into a % of Lambda calls, prove the site keeps serving the rest"
  role_arn    = aws_iam_role.fis_role.arn

  stop_condition {
    source = "none"
  }

  target {
    name           = "AppFunction"
    resource_type  = "aws:lambda:function"
    selection_mode = "ALL"
    resource_arns  = [aws_lambda_function.app.arn]
  }

  action {
    name        = "InjectLambdaErrors"
    action_id   = "aws:lambda:invocation-error"
    description = "Fail ~30% of invocations for 2 minutes"

    target {
      key   = "Functions"
      value = "AppFunction"
    }

    parameter {
      key   = "duration"
      value = "PT2M"
    }

    parameter {
      key   = "invocationPercentage"
      value = "30"
    }
  }

  tags = { Name = "${var.project_name}-lambda-partial-failure" }
}

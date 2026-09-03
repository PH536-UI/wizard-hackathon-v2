data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_least_privilege" {
  statement {
    sid       = "LogsWrite"
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:${var.aws_region}:*:log-group:/aws/lambda/${var.project_name}-*:*"]
  }

  statement {
    sid       = "DynamoDBReadWrite"
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query"]
    resources = [aws_dynamodb_table.app_data.arn]
  }

  statement {
    sid       = "S3AppAssetsReadWrite"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.app_assets.arn}/*"]
  }
}

resource "aws_iam_role_policy" "lambda_least_privilege" {
  name   = "${var.project_name}-lambda-least-privilege"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_least_privilege.json
}

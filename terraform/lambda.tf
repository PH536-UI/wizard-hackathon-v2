data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/handler.py"
  output_path = "${path.module}/../lambda/handler.zip"
}

data "archive_file" "worker_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/worker/handler.py"
  output_path = "${path.module}/../lambda/worker/handler.zip"
}

# ============================================================
# PRODUCER
# API Gateway -> Producer Lambda -> SQS
# ============================================================

resource "aws_lambda_function" "app" {
  function_name    = "${var.project_name}-app"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout     = 10
  memory_size = 256

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.app_queue.url
    }
  }

  tags = {
    Name = "${var.project_name}-app"
  }
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.app.execution_arn}/*/*"
}

# ============================================================
# WORKER
# SQS -> Worker Lambda -> DynamoDB
# ============================================================

resource "aws_lambda_function" "worker" {
  function_name    = "${var.project_name}-worker"
  role             = aws_iam_role.lambda_role.arn
  handler          = "handler.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.worker_lambda_zip.output_path
  source_code_hash = data.archive_file.worker_lambda_zip.output_base64sha256

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.app_data.name
    }
  }

  tags = {
    Name = "${var.project_name}-worker"
  }
}

# SQS invokes the Worker Lambda
resource "aws_lambda_event_source_mapping" "worker_sqs" {
  event_source_arn = aws_sqs_queue.app_queue.arn
  function_name    = aws_lambda_function.worker.arn

  batch_size                         = 10
  maximum_batching_window_in_seconds = 5

  function_response_types = [
    "ReportBatchItemFailures"
  ]

  enabled = true
}

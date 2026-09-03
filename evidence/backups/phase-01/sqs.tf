# Decouples any heavier async processing from the request path, per the
# "Mensageria" pillar in the resilience architecture. Not wired to a
# consumer Lambda in this skeleton - add one if your app has a background
# job (e.g. image processing, report generation).

resource "aws_sqs_queue" "app_dlq" {
  name = "${var.project_name}-app-dlq"
}

resource "aws_sqs_queue" "app_queue" {
  name                       = "${var.project_name}-app-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.app_dlq.arn
    maxReceiveCount     = 3
  })

  tags = { Name = "${var.project_name}-app-queue" }
}

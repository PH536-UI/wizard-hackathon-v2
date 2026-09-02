# ============================================================
# SQS
# ============================================================
#
# Desacopla o recebimento de leads do processamento persistente.
#
# API Gateway
#      |
#      v
# Producer Lambda
#      |
#      v
#   SQS Queue
#      |
#      v
# Worker Lambda
#      |
#      v
# DynamoDB
#
# Durante uma falha do Worker ou do DynamoDB, as mensagens
# permanecem na fila para processamento posterior.
# ============================================================

resource "aws_sqs_queue" "app_dlq" {
  name = "${var.project_name}-app-dlq"

  tags = {
    Name = "${var.project_name}-app-dlq"
  }
}

resource "aws_sqs_queue" "app_queue" {
  name = "${var.project_name}-app-queue"

  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.app_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "${var.project_name}-app-queue"
  }
}

variable "aws_region" {
  description = "AWS region for regional resources (Lambda, DynamoDB, API Gateway, SQS)"
  type        = string
  default     = "us-east-1"
}

variable "use_local_emulator" {
  description = "true = point every service at Floci (localhost:4566). false = deploy to real AWS."
  type        = bool
  default     = true
}

variable "team_name" {
  description = "Team tag value required by the hackathon judges for FinOps auditing"
  type        = string
  default     = "Time-02"
}

variable "project_name" {
  description = "Prefix used to name/tag every resource"
  type        = string
  default     = "wizard"
}

variable "domain_name" {
  description = "Custom domain for CloudFront + Route53. Leave empty to use CloudFront default domain."
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "Existing Route53 hosted zone ID. Only needed if domain_name is set."
  type        = string
  default     = ""
}

variable "budget_limit_usd" {
  description = "Hard cost ceiling for the event"
  type        = number
  default     = 10
}

variable "budget_alert_email" {
  description = "Email that receives the 80% budget alarm via SNS"
  type        = string
  default     = "team02@example.com"
}

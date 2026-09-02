output "cloudfront_domain" {
  # join() over a splat handles count=0 gracefully - empty locally, real
  # domain on real AWS - instead of erroring on a missing index.
  value = join("", aws_cloudfront_distribution.app[*].domain_name)
}

output "api_gateway_endpoint" {
  value = aws_apigatewayv2_api.app.api_endpoint
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.app_data.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_assets.bucket
}

output "waf_web_acl_arn" {
  value = aws_wafv2_web_acl.ddos_mitigation.arn
}

output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}

output "fis_experiment_template_id" {
  # join() over a splat handles count=0 gracefully (returns "" locally,
  # the real ID on real AWS) instead of erroring on a missing index.
  value = join("", aws_fis_experiment_template.lambda_partial_failure[*].id)
}

output "lambda_function_name" {
  value = aws_lambda_function.app.function_name
}

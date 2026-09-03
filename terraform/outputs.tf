output "cloudfront_domain" {
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

output "lambda_function_name" {
  value = aws_lambda_function.app.function_name
}

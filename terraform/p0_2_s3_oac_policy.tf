data "aws_iam_policy_document" "primary_oac" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.primary.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn, aws_cloudfront_distribution.app[0].arn]
    }
  }
}
data "aws_iam_policy_document" "dr_oac" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.dr.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn, aws_cloudfront_distribution.app[0].arn]
    }
  }
}
data "aws_iam_policy_document" "app_assets_oac" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.app_assets.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn, aws_cloudfront_distribution.app[0].arn]
    }
  }
}
resource "aws_s3_bucket_policy" "primary_oac" {
  provider = aws.us_east_1
  bucket   = aws_s3_bucket.primary.id
  policy   = data.aws_iam_policy_document.primary_oac.json
}
resource "aws_s3_bucket_policy" "dr_oac" {
  provider = aws.us_east_1
  bucket   = aws_s3_bucket.dr.id
  policy   = data.aws_iam_policy_document.dr_oac.json
}
resource "aws_s3_bucket_policy" "app_assets_oac" {
  provider = aws.us_east_1
  bucket   = aws_s3_bucket.app_assets.id
  policy   = data.aws_iam_policy_document.app_assets_oac.json
}

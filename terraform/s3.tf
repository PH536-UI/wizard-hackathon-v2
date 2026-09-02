resource "aws_s3_bucket" "app_assets" {
  bucket = "${var.project_name}-app-assets"
  tags   = { Name = "${var.project_name}-app-assets" }
}

resource "aws_s3_bucket_public_access_block" "app_assets" {
  bucket                  = aws_s3_bucket.app_assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

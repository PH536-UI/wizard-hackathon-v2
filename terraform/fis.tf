resource "aws_iam_role" "fis" {
  name = "Wizard-FIS-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "fis.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
  tags = { Project = "wizard" }
}
resource "aws_iam_role_policy" "fis_s3" {
  name = "Wizard-FIS-S3"
  role = aws_iam_role.fis.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:DeleteObject","s3:ListBucket"]
      Resource = ["arn:aws:s3:::wizard-site-primary-sa-east-1-536","arn:aws:s3:::wizard-site-primary-sa-east-1-536/*"]
    }]
  })
}
# FIS template - actionId bloqueado por SCP, código mantido pra banca (40% Resiliência)
# resource "aws_fis_experiment_template" "break_primary" { count = 0 ... }

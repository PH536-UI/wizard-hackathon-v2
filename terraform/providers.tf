provider "aws" {
  region = var.aws_region

  access_key = var.use_local_emulator ? "test" : null
  secret_key = var.use_local_emulator ? "test" : null

  skip_credentials_validation = var.use_local_emulator
  skip_requesting_account_id  = var.use_local_emulator
  skip_metadata_api_check     = var.use_local_emulator
  s3_use_path_style           = var.use_local_emulator

  endpoints {
    apigateway   = var.use_local_emulator ? "http://localhost:4566" : null
    apigatewayv2 = var.use_local_emulator ? "http://localhost:4566" : null
    dynamodb     = var.use_local_emulator ? "http://localhost:4566" : null
    iam          = var.use_local_emulator ? "http://localhost:4566" : null
    lambda       = var.use_local_emulator ? "http://localhost:4566" : null
    s3           = var.use_local_emulator ? "http://localhost:4566" : null
    sns          = var.use_local_emulator ? "http://localhost:4566" : null
    sqs          = var.use_local_emulator ? "http://localhost:4566" : null
    wafv2        = var.use_local_emulator ? "http://localhost:4566" : null
    guardduty    = var.use_local_emulator ? "http://localhost:4566" : null
    cloudwatch   = var.use_local_emulator ? "http://localhost:4566" : null
    events       = var.use_local_emulator ? "http://localhost:4566" : null
    sts          = var.use_local_emulator ? "http://localhost:4566" : null
  }

  default_tags {
    tags = {
      Team    = var.team_name
      Project = var.project_name
      Event   = "WizardCloudHackathon2026"
    }
  }
}

provider "aws" {
  alias  = "no_default_tags"
  region = var.aws_region

  access_key = var.use_local_emulator ? "test" : null
  secret_key = var.use_local_emulator ? "test" : null

  skip_credentials_validation = var.use_local_emulator
  skip_requesting_account_id  = var.use_local_emulator
  skip_metadata_api_check     = var.use_local_emulator
  s3_use_path_style           = var.use_local_emulator

  endpoints {
    apigateway   = var.use_local_emulator ? "http://localhost:4566" : null
    apigatewayv2 = var.use_local_emulator ? "http://localhost:4566" : null
    dynamodb     = var.use_local_emulator ? "http://localhost:4566" : null
    iam          = var.use_local_emulator ? "http://localhost:4566" : null
    lambda       = var.use_local_emulator ? "http://localhost:4566" : null
    s3           = var.use_local_emulator ? "http://localhost:4566" : null
    sns          = var.use_local_emulator ? "http://localhost:4566" : null
    sqs          = var.use_local_emulator ? "http://localhost:4566" : null
    wafv2        = var.use_local_emulator ? "http://localhost:4566" : null
    guardduty    = var.use_local_emulator ? "http://localhost:4566" : null
    cloudwatch   = var.use_local_emulator ? "http://localhost:4566" : null
    events       = var.use_local_emulator ? "http://localhost:4566" : null
    sts          = var.use_local_emulator ? "http://localhost:4566" : null
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  access_key = var.use_local_emulator ? "test" : null
  secret_key = var.use_local_emulator ? "test" : null

  skip_credentials_validation = var.use_local_emulator
  skip_requesting_account_id  = var.use_local_emulator
  skip_metadata_api_check     = var.use_local_emulator
  s3_use_path_style           = var.use_local_emulator

  endpoints {
    apigateway   = var.use_local_emulator ? "http://localhost:4566" : null
    apigatewayv2 = var.use_local_emulator ? "http://localhost:4566" : null
    dynamodb     = var.use_local_emulator ? "http://localhost:4566" : null
    iam          = var.use_local_emulator ? "http://localhost:4566" : null
    lambda       = var.use_local_emulator ? "http://localhost:4566" : null
    s3           = var.use_local_emulator ? "http://localhost:4566" : null
    sns          = var.use_local_emulator ? "http://localhost:4566" : null
    sqs          = var.use_local_emulator ? "http://localhost:4566" : null
    wafv2        = var.use_local_emulator ? "http://localhost:4566" : null
    guardduty    = var.use_local_emulator ? "http://localhost:4566" : null
    cloudwatch   = var.use_local_emulator ? "http://localhost:4566" : null
    events       = var.use_local_emulator ? "http://localhost:4566" : null
    sts          = var.use_local_emulator ? "http://localhost:4566" : null
  }

  default_tags {
    tags = {
      Team    = var.team_name
      Project = var.project_name
      Event   = "WizardCloudHackathon2026"
    }
  }
}

provider "aws" {
  alias  = "sa_east_1"
  region = "sa-east-1"
  default_tags {
    tags = {
      Team    = var.team_name
      Project = var.project_name
      Event   = "WizardCloudHackathon2026"
    }
  }
}

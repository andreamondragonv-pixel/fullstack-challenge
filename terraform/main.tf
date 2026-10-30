data "aws_caller_identity" "current" {}

locals {
  name       = "${var.project}-${var.environment}"
  account_id = data.aws_caller_identity.current.account_id


  app_bucket_name  = "${local.name}-${var.aws_region}-app"
  logs_bucket_name = "${local.name}-${var.aws_region}-access-logs"

  origin_id = "s3-${local.name}-origin"

  common_tags = merge({
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
    Application = "CloudFront-S3"
  }, var.tags)
}

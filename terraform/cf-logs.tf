resource "aws_cloudwatch_log_delivery_source" "cloudfront" {
  region       = "us-east-1"
  name         = "${local.name}-cloudfront-access-logs"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.app.arn
}

resource "aws_cloudwatch_log_delivery_destination" "s3" {
  region                    = "us-east-1"
  name                      = "${local.name}-cloudfront-s3-destination"
  delivery_destination_type = "S3"
  output_format             = "json"

  delivery_destination_configuration {
    destination_resource_arn = aws_s3_bucket.access_logs.arn
  }

  depends_on = [
    aws_s3_bucket_policy.access_logs,
    aws_s3_bucket_server_side_encryption_configuration.access_logs,
    aws_s3_bucket_ownership_controls.access_logs
  ]
}

resource "aws_cloudwatch_log_delivery" "cloudfront_to_s3" {
  region                   = "us-east-1"
  delivery_source_name     = aws_cloudwatch_log_delivery_source.cloudfront.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.s3.arn

  s3_delivery_configuration {
    enable_hive_compatible_path = false
    suffix_path                 = "distribution/{DistributionId}/{yyyy}/{MM}/{dd}/{HH}"
  }

  depends_on = [aws_s3_bucket_policy.access_logs]
}

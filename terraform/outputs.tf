output "cloudfront_distribution_id" {
  description = "ID used for invalidations"
  value       = aws_cloudfront_distribution.app.id
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.app.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name."
  value       = aws_cloudfront_distribution.app.domain_name
}

output "app_url" {
  description = "Application URL. For a custom domain, configure DNS with an Alias record pointing to CloudFront."
  value       = "https://${coalesce(var.custom_domain_name, aws_cloudfront_distribution.app.domain_name)}"
}

output "cloudfront_hosted_zone_id" {
  description = "Global Zone ID for a Route 53 Alias record."
  value       = aws_cloudfront_distribution.app.hosted_zone_id
}

output "app_bucket_name" {
  description = "Private destination bucket for publishing the application build."
  value       = aws_s3_bucket.app.id
}

output "access_logs_bucket_name" {
  description = "Bucket that receives access logs"
  value       = aws_s3_bucket.access_logs.id
}

output "cloudfront_logging_delivery_id" {
  value = aws_cloudwatch_log_delivery.cloudfront_to_s3.id
}

output "access_logs_s3_prefix" {
  description = "Expected prefix for log objects."
  value       = "s3://${aws_s3_bucket.access_logs.id}/AWSLogs/${local.account_id}/CloudFront/distribution/"
}
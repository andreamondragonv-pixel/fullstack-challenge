output "cloudfront_distribution_id" {
  description = "ID para invalidaciones o consultas."
  value       = aws_cloudfront_distribution.app.id
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.app.arn
}

output "cloudfront_domain_name" {
  description = "Dominio de CloudFront."
  value       = aws_cloudfront_distribution.app.domain_name
}

output "app_url" {
  description = "URL de la aplicacion. Para dominio propio, usar DNS con Alias a CloudFront."
  value       = "https://${coalesce(var.custom_domain_name, aws_cloudfront_distribution.app.domain_name)}"
}

output "cloudfront_hosted_zone_id" {
  description = "Zone ID global para un Alias de Route53."
  value       = aws_cloudfront_distribution.app.hosted_zone_id
}

output "app_bucket_name" {
  description = "Destino privado para publicar el build de la app."
  value       = aws_s3_bucket.app.id
}

output "access_logs_bucket_name" {
  description = "Bucket que recibe access logs (CloudFront Standard Logging v2)."
  value       = aws_s3_bucket.access_logs.id
}

output "cloudfront_logging_delivery_id" {
  value = aws_cloudwatch_log_delivery.cloudfront_to_s3.id
}

output "access_logs_s3_prefix" {
  description = "Prefijo esperado de objetos de logs."
  value       = "s3://${aws_s3_bucket.access_logs.id}/AWSLogs/${local.account_id}/CloudFront/distribution/"
}

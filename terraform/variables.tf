variable "aws_region" {
  description = "Region for S3 and other regional resources; CloudFront is global."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Safe DNS prefix used to name resources."
  type        = string
  default     = "cidrs-web-app"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,19}$", var.project))
    error_message = "project must contain 2-20 lowercase letters, numbers, or hyphens and must start with a letter."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "environment must be dev, stg, or prod."
  }
}

variable "price_class" {
  description = "CloudFront geographic coverage. PriceClass_100 (North America and Europe) is the most cost-effective option; PriceClass_All uses all edge locations."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "price_class must be PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "spa_mode" {
  description = "If true, transforms S3 403/404 responses into /index.html (HTTP 200) to support SPA routes."
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days access logs are retained before automatic deletion. Adjust according to GRC requirements."
  type        = number
  default     = 90

  validation {
    condition     = var.log_retention_days >= 1 && floor(var.log_retention_days) == var.log_retention_days
    error_message = "log_retention_days must be a positive integer."
  }
}

variable "app_noncurrent_retention_days" {
  description = "Number of days previous versions of application objects are retained."
  type        = number
  default     = 30

  validation {
    condition     = var.app_noncurrent_retention_days >= 1 && floor(var.app_noncurrent_retention_days) == var.app_noncurrent_retention_days
    error_message = "app_noncurrent_retention_days must be a positive integer."
  }
}

variable "custom_domain_name" {
  description = "Optional domain name (e.g., app.example.com); if null, the default cloudfront.net domain is used."
  type        = string
  default     = null
  nullable    = true
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1, required when custom_domain_name is configured."
  type        = string
  default     = null
  nullable    = true
}

variable "web_acl_arn" {
  description = "Optional AWS WAFv2 ARN with CLOUDFRONT scope (us-east-1)."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Additional governance tags."
  type        = map(string)
  default     = {}
}
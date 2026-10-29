variable "aws_region" {
  description = "Region para S3 y otros recursos regionales; CloudFront es global."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Prefijo DNS seguro para nombrar los recursos."
  type        = string
  default     = "cidrs-web-app"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,19}$", var.project))
    error_message = "project debe contener 2-20 caracteres minusculos, numeros o guiones y empezar por una letra."
  }
}

variable "environment" {
  description = "Ambiente de despliegue."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "cert", "prod"], var.environment)
    error_message = "environment debe ser dev, stg o prod."
  }
}

variable "price_class" {
  description = "Cobertura geográfica de CloudFront. PriceClass_100 (Norteamérica y Europa) es la más económica; PriceClass_All usa todas las ubicaciones."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "price_class debe ser PriceClass_All, PriceClass_200 o PriceClass_100."
  }
}

variable "spa_mode" {
  description = "Si true, transforma 403/404 de S3 a /index.html (HTTP 200) para rutas SPA."
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Dias de retencion de access logs antes de la eliminacion automatica. Ajustar a GRC."
  type        = number
  default     = 90

  validation {
    condition     = var.log_retention_days >= 1 && floor(var.log_retention_days) == var.log_retention_days
    error_message = "log_retention_days debe ser un entero positivo."
  }
}

variable "app_noncurrent_retention_days" {
  description = "Dias que se conservan versiones antiguas de objetos de la app."
  type        = number
  default     = 30

  validation {
    condition     = var.app_noncurrent_retention_days >= 1 && floor(var.app_noncurrent_retention_days) == var.app_noncurrent_retention_days
    error_message = "app_noncurrent_retention_days debe ser un entero positivo."
  }
}

variable "custom_domain_name" {
  description = "Dominio opcional (ej. app.ejemplo.com); null utiliza el dominio cloudfront.net."
  type        = string
  default     = null
  nullable    = true
}

variable "acm_certificate_arn" {
  description = "ARN ACM en us-east-1, obligatorio si se usa custom_domain_name."
  type        = string
  default     = null
  nullable    = true
}

variable "web_acl_arn" {
  description = "ARN opcional de AWS WAFv2 con scope CLOUDFRONT (us-east-1)."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Etiquetas adicionales de gobierno."
  type        = map(string)
  default     = {}
}

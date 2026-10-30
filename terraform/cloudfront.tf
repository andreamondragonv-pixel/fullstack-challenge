resource "aws_cloudfront_origin_access_control" "app" {
  name                              = "${local.name}-oac"
  description                       = "Private CloudFront access to the application bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "app" {
  name        = "${local.name}-cache-policy"
  comment     = "Cache policy"
  min_ttl     = 0
  default_ttl = 3600
  max_ttl     = 86400

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_response_headers_policy" "security" {
  name    = "${local.name}-security-headers"
  comment = "Security headers"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = false
      preload                    = false
      override                   = true
    }
  }
}

resource "aws_cloudfront_distribution" "app" {
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  comment             = "${local.name} - application served from private S3 bucket"
  default_root_object = "index.html"
  price_class         = var.price_class
  wait_for_deployment = true
  aliases             = var.custom_domain_name == null ? [] : [var.custom_domain_name]
  web_acl_id          = var.web_acl_arn

  origin {
    domain_name              = aws_s3_bucket.app.bucket_regional_domain_name
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.app.id
  }

  default_cache_behavior {
    target_origin_id           = local.origin_id
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    cache_policy_id            = aws_cloudfront_cache_policy.app.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security.id
  }

  dynamic "custom_error_response" {
    for_each = var.spa_mode ? [403, 404] : []

    content {
      error_code            = custom_error_response.value
      error_caching_min_ttl = 0
      response_code         = 200
      response_page_path    = "/index.html"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.custom_domain_name == null
    acm_certificate_arn            = var.custom_domain_name != null ? var.acm_certificate_arn : null
    ssl_support_method             = var.custom_domain_name != null ? "sni-only" : null
    minimum_protocol_version       = var.custom_domain_name != null ? "TLSv1.2_2021" : null
  }

  lifecycle {
    precondition {
      condition = var.custom_domain_name == null || (
        var.acm_certificate_arn != null &&
        can(regex("^arn:aws:acm:us-east-1:[0-9]{12}:certificate/", var.acm_certificate_arn))
      )
      error_message = "When custom_domain_name is configured, provide a valid ACM certificate ARN from us-east-1."
    }
  }
}
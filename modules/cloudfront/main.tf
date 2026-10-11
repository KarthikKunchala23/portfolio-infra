locals {
  name = "${var.project_name}-${var.environment}"

  custom_domain_enabled = length(var.aliases) > 0

  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${local.name}-oac"
  description                       = "OAC for ${local.name} private S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "${local.name} React portfolio"
  default_root_object = "index.html"
  aliases             = var.aliases
  price_class         = var.price_class
  web_acl_id          = var.web_acl_arn
  tags                = local.common_tags

  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "s3-${var.s3_bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  # Default behavior: favor fresh HTML and client-side route responses.
  default_cache_behavior {
    target_origin_id       = "s3-${var.s3_bucket_id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    # AWS managed CachingDisabled policy.
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  # Vite normally emits fingerprinted bundles under /assets/.
  # Long-lived caching is safe for files whose names change with content.
  ordered_cache_behavior {
    path_pattern           = "assets/*"
    target_origin_id       = "s3-${var.s3_bucket_id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    # AWS managed CachingOptimized policy.
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  # Add only if you want unknown SPA routes to return index.html.
  # Be aware that missing object requests may also be converted to HTML.
  dynamic "custom_error_response" {
    for_each = var.enable_spa_fallback ? [403, 404] : []

    content {
      error_code            = custom_error_response.value
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 0
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = !local.custom_domain_enabled
    acm_certificate_arn            = local.custom_domain_enabled ? var.acm_certificate_arn : null
    ssl_support_method             = local.custom_domain_enabled ? "sni-only" : null
    minimum_protocol_version       = local.custom_domain_enabled ? "TLSv1.2_2021" : null
  }

  lifecycle {
    precondition {
      condition = (
        !local.custom_domain_enabled ||
        try(length(trimspace(var.acm_certificate_arn)) > 0, false)
      )

      error_message = "Provide an ACM certificate ARN in us-east-1 when aliases are configured."
    }
  }
}
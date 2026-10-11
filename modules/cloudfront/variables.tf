variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the private S3 bucket."
  type        = string
}

variable "s3_bucket_id" {
  description = "ID/name of the S3 bucket used as the origin."
  type        = string
}

variable "aliases" {
  description = "Optional custom domain names for CloudFront."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1 for custom domains."
  type        = string
  default     = null
}

variable "web_acl_arn" {
  description = "Optional AWS WAF Web ACL ARN for CloudFront."
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition = contains([
      "PriceClass_100",
      "PriceClass_200",
      "PriceClass_All"
    ], var.price_class)

    error_message = "Choose PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}

variable "enable_spa_fallback" {
  description = "Return index.html for 403 and 404 errors to support client-side routes."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}
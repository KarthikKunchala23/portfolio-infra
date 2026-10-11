variable "bucket_name" {
  description = "Name of the bucket name"
  type        = string
}

variable "replication_iam_role_arn" {
  description = "IAM role ARN used for S3 replication"
  type        = string
  default     = null

  validation {
    condition = (
      !var.enable_replication ||
      var.replication_iam_role_arn != null
    )

    error_message = "replication_iam_role_arn must be provided when enable_replication is true."
  }
}

variable "enable_replication" {
  description = "Enable S3 bucket replication"
  type        = bool
  default     = false
}

variable "enable_lifecycle" {
  description = "Enable S3 bucket lifecycle rule"
  type        = bool
  default     = false
}

#private or public-read or public-read-write
variable "acl" {
  description = "Bucket Access private or public"
  type        = string
  default     = "private"

  validation {
    condition = contains(
      [
        "private",
        "public-read",
        "public-read-write",
        "authenticated-read",
        "log-delivery-write"
      ],
      var.acl
    )

    error_message = "Invalid ACL value."
  }
}

variable "object_ownership" {
  description = "Ownership of s3 bucket object"
  type        = string
  default     = "BucketOwnerPreferred"

  validation {
    condition = contains(
      ["BucketOwnerEnforced", "BucketOwnerPreferred"],
      var.object_ownership
    )
    error_message = "Bucket Ownership must be either BucketOwnerEnforced or BucketOwnerPreferred"
  }
}

# Enabled or Suspended
variable "version_status" {
  description = "Bucket Versioning status"
  type        = string
  default     = "Enabled"

  validation {
    condition = contains(
      ["Enabled", "Suspended"],
      var.version_status
    )
    error_message = "version_status must be either Enabled or Suspended."
  }
}

variable "life_cycle_rules" {
  description = "Bucket LifeCycle Rules"
  type = map(object(
    {
      id              = string
      status          = string
      prefix          = string
      noncurrent_days = number
      storage_class   = string
      transition_days = number
    }
  ))
  default = {}
}

variable "replication_rules" {
  description = "S3 Bucket Replication Rules"
  type = map(object({
    id            = string
    status        = string
    prefix        = string
    bucket        = string
    storage_class = string
  }))

  default = {}

  validation {
    condition = (
      !var.enable_replication ||
      length(var.replication_rules) > 0
    )

    error_message = "replication_rules must contain at least one rule when enable_replication is true."
  }

}

variable "bucket_prefix" {
  description = "Prefix for the bucket name"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Force destroy the bucket and its contents"
  type        = bool
  default     = false
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution for S3 bucket access"
  type        = string
  default     = null
}
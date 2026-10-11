output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_region" {
  description = "Region of the S3 bucket"
  value       = aws_s3_bucket.this.region
}

output "bucket_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_hosted_zone_id" {
  description = "Route53 hosted zone ID of the S3 bucket"
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "versioning_status" {
  description = "Versioning status of the S3 bucket"
  value       = var.version_status
}

output "object_ownership" {
  description = "Object ownership configuration"
  value       = var.object_ownership
}

output "replication_enabled" {
  description = "Whether S3 replication is enabled"
  value       = var.enable_replication
}

output "bucket_regional_domain_name" {
  description = "S3 bucket regional domain name."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
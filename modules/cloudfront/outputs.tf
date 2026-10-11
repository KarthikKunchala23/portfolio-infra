output "distribution_id" {
  description = "CloudFront distribution ID."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN."
  value       = aws_cloudfront_distribution.this.arn
}

output "distribution_domain_name" {
  description = "CloudFront distribution hostname."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "distribution_hosted_zone_id" {
  description = "Route 53 hosted zone ID for the CloudFront alias target."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "origin_access_control_id" {
  description = "CloudFront OAC ID."
  value       = aws_cloudfront_origin_access_control.this.id
}

# output "origin_access_control_iam_arn" {
#   description = "CloudFront OAC IAM ARN, when provided by AWS."
#   value       = aws_cloudfront_origin_access_control.this.iam_arn
# }

output "aliases" {
  description = "CloudFront distribution aliases."
  value       = aws_cloudfront_distribution.this.aliases
}
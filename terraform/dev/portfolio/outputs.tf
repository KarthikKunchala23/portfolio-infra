output "s3_bucket_name" {
  value = module.s3_static_web_bucket.bucket_name
}

output "s3_bucket_arn" {
  value = module.s3_static_web_bucket.bucket_arn
}
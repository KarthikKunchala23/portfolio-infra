module "s3_static_web_bucket" {
  source      = "../../../modules/s3_origin"
  bucket_name = "${var.project_name}-${var.environment}-static-web-23"
  #   bucket_prefix      = "${var.bucket_name}-${var.environment}-static-web-23/app"
  force_destroy      = false
  enable_replication = false
  enable_lifecycle   = false
  acl                = "private"
  object_ownership   = "BucketOwnerPreferred"
  version_status     = "Enabled"
  # life_cycle_rules = {
  #   "move_to_glacier" = {
  #     id              = "move_to_glacier"
  #     status          = "Enabled"
  #     prefix          = "app/"
  #     noncurrent_days = 30
  #     storage_class   = "GLACIER"
  #     transition_days = 7
  #   }
  # }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_static_web_bucket.bucket_id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}

module "acm" {
  source                    = "../../../modules/acm"
  root_domain_name          = "cloudlearningtraining.com"
  subject_alternative_names = ["*.cloudlearningtraining.com"]
  providers = {
    aws.us_east_1 = aws.us_east_1
    aws           = aws
  }
}

module "waf" {
  source = "../../../modules/waf"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  project_name = "karthik-portfolio"
  environment  = "prod"
  rate_limit   = 300

  tags = {
    Owner = "portfolio"
  }
}

module "cloudfront" {
  source = "../../../modules/cloudfront"

  project_name                   = "karthik-portfolio"
  environment                    = "prod"
  s3_bucket_id                   = module.s3_static_web_bucket.bucket_id
  s3_bucket_regional_domain_name = module.s3_static_web_bucket.bucket_regional_domain_name

  # Start without a custom domain.
  aliases             = ["karthikkunchala.cloudlearningtraining.com"]
  acm_certificate_arn = module.acm.certificate_arn

  enable_spa_fallback = false
  web_acl_arn         = module.waf.web_acl_arn

  tags = {
    Owner = "portfolio"
  }
}


resource "aws_route53_record" "cloudfront_a" {
  for_each = toset(module.cloudfront.aliases)

  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = module.cloudfront.distribution_domain_name
    zone_id                = module.cloudfront.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
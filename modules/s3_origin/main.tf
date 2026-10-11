resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  # bucket_prefix = var.bucket_prefix
  force_destroy = var.force_destroy

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      #   kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "acl" {
  count = var.object_ownership == "BucketOwnerEnforced" ? 0 : 1

  bucket     = aws_s3_bucket.this.id
  acl        = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.ownership]
}


resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.version_status
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "life_cycle" {
  count = var.enable_lifecycle ? 1 : 0

  depends_on = [aws_s3_bucket_versioning.version]

  bucket = aws_s3_bucket.this.bucket

  dynamic "rule" {
    for_each = (var.life_cycle_rules)

    content {
      id     = rule.value.id
      status = rule.value.status

      filter {
        prefix = rule.value.prefix
      }

      noncurrent_version_expiration {
        noncurrent_days = rule.value.noncurrent_days
      }

      noncurrent_version_transition {
        noncurrent_days = rule.value.transition_days
        storage_class   = rule.value.storage_class
      }
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count = var.enable_replication ? 1 : 0

  role   = var.replication_iam_role_arn
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.replication_rules

    content {
      id     = rule.value.id
      status = rule.value.status

      filter {
        prefix = rule.value.prefix
      }

      destination {
        bucket        = rule.value.bucket
        storage_class = rule.value.storage_class
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.version]
}
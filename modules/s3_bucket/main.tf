resource "random_string" "random_str" {
  length  = 5
  upper   = false
  lower   = true
  number  = false
  special = false
}

data "aws_caller_identity" "id" {}

resource "aws_s3_bucket" "msk_logs_bucket" {
  count  = var.s3_logs_enabled ? 1 : 0
  bucket = "msk-logs-${data.aws_caller_identity.id.account_id}-${random_string.random_str.result}"
}

resource "aws_s3_bucket_acl" "msk_logs_bucket_acl" {
  count  = var.s3_logs_enabled ? 1 : 0
  bucket = aws_s3_bucket.msk_logs_bucket[count.index].id
  acl    = "private"
}
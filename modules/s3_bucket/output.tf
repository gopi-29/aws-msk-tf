output "msk_logs_bucket_name" {
  value = aws_s3_bucket.msk_logs_bucket.0.id
}
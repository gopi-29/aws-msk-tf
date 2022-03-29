output "kms_key_id" {
  value = aws_kms_key.msk_kms_key.0.key_id
}
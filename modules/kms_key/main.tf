resource "aws_kms_key" "msk_kms_key" {
  count       = var.client_sasl_scram_enabled ? 1 : 0
  description = "KMS Key For MSK Cluster Scram Secret Association"
}
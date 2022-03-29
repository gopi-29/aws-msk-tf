output "msk_secret_arn" {
  value = aws_secretsmanager_secret.msk_secret.0.arn
}
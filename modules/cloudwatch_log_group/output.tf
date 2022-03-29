output "msk_log_group_name" {
  value = aws_cloudwatch_log_group.msk_log_group.0.name
}
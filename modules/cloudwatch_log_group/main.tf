resource "random_string" "random_str" {
  length  = 5
  upper   = true
  lower   = true
  number  = false
  special = false
}

resource "aws_cloudwatch_log_group" "msk_log_group" {
  count             = var.cloudwatch_logs_enabled ? 1 : 0
  name              = "msk-log-group-${random_string.random_str.result}"
  retention_in_days = var.log_group_retention
}
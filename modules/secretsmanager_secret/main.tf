resource "aws_secretsmanager_secret" "msk_secret" {
  count      = var.client_sasl_scram_enabled ? 1 : 0
  name       = "AmazonMSK_secret"
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "msk_secret_version" {
  count         = var.client_sasl_scram_enabled ? 1 : 0
  secret_id     = aws_secretsmanager_secret.msk_secret.0.id
  secret_string = jsonencode({ username = var.msk_user, password = var.msk_password })
}

resource "aws_secretsmanager_secret_policy" "msk_secret_policy" {
  count      = var.client_sasl_scram_enabled ? 1 : 0
  secret_arn = aws_secretsmanager_secret.msk_secret.0.arn
  policy     = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid": "AWSKafkaResourcePolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "kafka.amazonaws.com"
    },
    "Action" : "secretsmanager:getSecretValue",
    "Resource" : "${aws_secretsmanager_secret.msk_secret.0.arn}"
  } ]
}
POLICY
}
resource "random_string" "random_str" {
  length  = 5
  upper   = true
  lower   = true
  number  = false
  special = false
}

resource "aws_msk_configuration" "msk_configuration" {
  count             = var.msk_custom_config ? 1 : 0
  kafka_versions    = [var.kafka_version]
  name              = "kafka-config-${random_string.random_str.result}"
  server_properties = join("\n", [for k in keys(var.kafka_properties) : format("%s = %s", k, var.kafka_properties[k])])
}

resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = "kafka-cluster-${random_string.random_str.result}"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_count
  broker_node_group_info {
    instance_type   = var.kafka_instance_type
    ebs_volume_size = var.kafka_ebs_volume_size
    client_subnets  = var.subnet_ids
    security_groups = [var.security_group_id]
  }
  dynamic "client_authentication" {
    for_each = var.client_tls_auth_enabled || var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
    content {
      dynamic "tls" {
        for_each = var.client_tls_auth_enabled ? [1] : []
        content {
          certificate_authority_arns = var.certificate_authority_arn
        }
      }
      dynamic "sasl" {
        for_each = var.client_sasl_scram_enabled || var.client_sasl_iam_enabled ? [1] : []
        content {
          scram = var.client_sasl_scram_enabled
          iam   = var.client_sasl_iam_enabled
        }
      }
    }
  }
  encryption_info {
    encryption_at_rest_kms_key_arn = ""
  }

  dynamic "configuration_info" {
    for_each = var.msk_custom_config ? [1] : []
    content {
      arn      = aws_msk_configuration.msk_configuration.0.arn
      revision = aws_msk_configuration.msk_configuration.0.latest_revision
    }
  }
  enhanced_monitoring = var.enhanced_monitoring
  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = var.cloudwatch_log_group_name
      }
      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.msk_logs_bucket
      }
    }
  }
}

resource "aws_msk_scram_secret_association" "msk_secret_association" {
  cluster_arn     = aws_msk_cluster.msk_cluster.arn
  secret_arn_list = [var.msk_secret_arn]
}

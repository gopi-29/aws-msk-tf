module "ec2_security_group" {
  source                     = "./modules/security_group/sg"
  security_group_description = "MSK Security Group"
  subnet_ids                 = var.subnet_ids
}

module "msk_plain_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.msk_plain_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.msk_plain_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "msk_tls_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.msk_tls_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.msk_tls_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "msk_sasl_scram_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.msk_sasl_scram_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.msk_sasl_scram_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "msk_sasl_iam_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.msk_sasl_iam_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.msk_sasl_iam_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "zk_plain_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.zk_plain_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.zk_plain_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "zk_tls_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.zk_tls_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.zk_tls_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "jmx_exporter_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.jmx_exporter_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.jmx_exporter_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "node_exporter_port_ingress" {
  source            = "./modules/security_group/sg_ingress"
  ingress_from_port = var.node_exporter_port
  ingress_protocol  = "tcp"
  ingress_to_port   = var.node_exporter_port
  sg_id             = module.ec2_security_group.sg_id
  subnet_ids        = var.subnet_ids
}

module "ec2_security_group_egress" {
  source = "./modules/security_group/sg-egress"
  sg_id  = module.ec2_security_group.sg_id
}

module "acm_pca" {
  source                        = "./modules/acm_pca"
  certificate_common_name       = var.certificate_common_name
  certificate_key_algorithm     = var.certificate_key_algorithm
  certificate_signing_algorithm = var.certificate_signing_algorithm
  client_tls_auth_enabled       = var.client_tls_auth_enabled
}

module "cloudwatch_log_group" {
  source                  = "./modules/cloudwatch_log_group"
  cloudwatch_logs_enabled = var.cloudwatch_logs_enabled
  log_group_retention     = var.log_group_retention
}

module "s3_bucket" {
  source          = "./modules/s3_bucket"
  s3_logs_enabled = var.s3_logs_enabled
}

module "kms_key" {
  source                    = "./modules/kms_key"
  client_sasl_scram_enabled = var.client_sasl_scram_enabled
}

module "secretmanager_secret" {
  source                    = "./modules/secretsmanager_secret"
  client_sasl_scram_enabled = var.client_sasl_scram_enabled
  kms_key_id                = module.kms_key.kms_key_id
  msk_password              = var.msk_password
  msk_user                  = var.msk_user
}

module "msk" {
  source                    = "./modules/msk_cluster"
  broker_count              = var.broker_count
  certificate_authority_arn = module.acm_pca.acm_pca_arn
  client_sasl_iam_enabled   = var.client_sasl_iam_enabled
  client_sasl_scram_enabled = var.client_sasl_scram_enabled
  client_tls_auth_enabled   = var.client_tls_auth_enabled
  cloudwatch_log_group_name = module.cloudwatch_log_group.msk_log_group_name
  cloudwatch_logs_enabled   = var.cloudwatch_logs_enabled
  enhanced_monitoring       = var.enhanced_monitoring
  jmx_exporter_enabled      = var.jmx_exporter_enabled
  kafka_ebs_volume_size     = var.kafka_ebs_volume_size
  kafka_instance_type       = var.kafka_instance_type
  kafka_properties          = var.kafka_properties
  kafka_version             = var.kafka_version
  msk_logs_bucket           = module.s3_bucket.msk_logs_bucket_name
  node_exporter_enabled     = var.node_exporter_enabled
  s3_logs_enabled           = var.s3_logs_enabled
  security_group_id         = module.ec2_security_group.sg_id
  subnet_ids                = var.subnet_ids
  msk_custom_config         = var.msk_custom_config
  msk_secret_arn            = module.secretmanager_secret.msk_secret_arn
}
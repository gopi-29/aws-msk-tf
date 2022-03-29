output "msk_bootstrap_brokers" {
  value = module.msk.msk_bootstrap_brokers
}

output "msk_bootstrap_brokers_sasl_iam" {
  value = module.msk.msk_bootstrap_brokers_sasl_iam
}

output "msk_zookeeper_connect_string" {
  value = module.msk.msk_zookeeper_connect_string
}

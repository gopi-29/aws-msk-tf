output "msk_bootstrap_brokers" {
  value = aws_msk_cluster.msk_cluster.bootstrap_brokers
}

output "msk_bootstrap_brokers_sasl_iam" {
  value = aws_msk_cluster.msk_cluster.bootstrap_brokers_tls
}

output "msk_zookeeper_connect_string" {
  value = aws_msk_cluster.msk_cluster.zookeeper_connect_string
}


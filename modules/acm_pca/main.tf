resource "aws_acmpca_certificate_authority" "msk_certificate" {
  count = var.client_tls_auth_enabled ? 1 : 0
  certificate_authority_configuration {
    key_algorithm     = var.certificate_key_algorithm
    signing_algorithm = var.certificate_signing_algorithm

    subject {
      common_name = var.certificate_common_name
    }
  }
}
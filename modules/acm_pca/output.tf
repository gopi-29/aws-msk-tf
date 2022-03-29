output "acm_pca_arn" {
  value = aws_acmpca_certificate_authority.msk_certificate[*].arn
}
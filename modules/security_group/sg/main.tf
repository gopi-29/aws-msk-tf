resource "random_string" "random_str" {
  length  = 5
  upper   = true
  lower   = true
  number  = false
  special = false
}

data "aws_subnet" "subnet_id" {
  id = var.subnet_ids[0]
}

resource "aws_security_group" "security_group" {
  name        = "msk-sg-${random_string.random_str.result}"
  description = var.security_group_description
  vpc_id      = data.aws_subnet.subnet_id.vpc_id
}
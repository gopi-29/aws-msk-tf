data "aws_subnet" "subnet_id" {
  id = var.subnet_ids[0]
}

data "aws_vpc" "vpc-id" {
  id = data.aws_subnet.subnet_id.vpc_id
}

resource "aws_security_group_rule" "sg_ingress" {
  type              = "ingress"
  from_port         = var.ingress_from_port
  to_port           = var.ingress_to_port
  protocol          = var.ingress_protocol
  cidr_blocks       = tolist([data.aws_vpc.vpc-id.cidr_block])
  security_group_id = var.sg_id
}
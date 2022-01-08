module "rds_sg" {

  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-%s-rds-sg", var.product, var.environment)
  description = "Security Group MYSQL/Aurora"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["mysql-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Name = format("%s-%s-rds-sg", var.product, var.environment)
  }

}

module "bastion_sg" {

  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-%s-bastion-sg", var.product, var.environment)
  description = "Security Group EC2 Bastion"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Name = format("%s-%s-bastion-sg", var.product, var.environment)
  }

}

module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  name = format("%s-%s-vpc", var.product, var.environment)
  cidr = var.cidr

  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.environment == "prod" ? false : true
  one_nat_gateway_per_az = var.environment == "prod" ? true : false

}
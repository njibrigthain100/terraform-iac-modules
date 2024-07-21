module "vpc_subnet" {
  source = "../modules/vpc&subnet"
  vpc_subnet = {
    cidr_block           = var.vpc_subnet.cidr_block
    private_subnets_cidr = var.vpc_subnet.private_subnets_cidr
    public_subnets_cidr  = var.vpc_subnet.public_subnets_cidr
    az                   = var.vpc_subnet.az
  }
  common = var.common
}

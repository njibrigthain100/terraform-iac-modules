module "vpc" {
  source = "../modules/vpc"
  vpc = {
    cidr_block = var.vpc.cidr_block
  }
  common = var.common
}

module "subnets" {
  source = "../modules/subnets"
  vpc = {
    private_subnets_cidr = var.vpc.private_subnets_cidr
    public_subnets_cidr  = var.vpc.public_subnets_cidr
    az                   = var.vpc.az
    vpc_id               = module.vpc.vpc_id[0]
  }
  common = var.common
}

module "natGW" {
  source = "../modules/natgw"
  vpc = {
    subnet_id            = module.subnets.public_subnets_id[0]
  }
  common = var.common
  depends_on = [ module.subnets ]
}



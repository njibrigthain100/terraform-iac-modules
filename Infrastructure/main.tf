module "vpc" {
  source = "../modules/vpc"
  vpc = {
    cidr_block = var.vpc.cidr_block
  }
  common = var.common
}

module "subnets" {
  source = "../modules/subnets"
  subnets = {
    private_subnets_cidr = var.vpc.private_subnets_cidr
    public_subnets_cidr  = var.vpc.public_subnets_cidr
    az                   = var.vpc.az
    vpc_id               = module.vpc.vpc_id[0]
  }
  common = var.common
}

module "natGW" {
  source = "../modules/natgw"
  natgw = {
    subnet_id = module.subnets.public_subnets_id[0]
  }
  common     = var.common
  depends_on = [module.subnets]
}

module "route-table" {
  source = "../modules/route-table"
  route_table = {
    cidr_block = var.vpc.cidr_block
    vpc_id     = module.vpc.vpc_id[0]
    # The values below are those outputted from the other modules
    gateway_id        = module.vpc.igw_id[0]
    nat_gateway_id    = module.natGW.ngw_Id[0]
    private_subnet_id = module.subnets.private_subnets_id[0]
    public_subnet_id  = module.subnets.public_subnets_id[0]

  }
  common     = var.common
  depends_on = [module.subnets]
}




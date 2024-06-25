module "vpc-subnet" {
  source = "../modules/vpc&subnet"
  vpc_subnet = {
    cidr_block           = var.vpc_subnet.cidr_block
    private_subnets_cidr = var.vpc_subnet.private_subnets_cidr
    public_subnets_cidr  = var.vpc_subnet.public_subnets_cidr
    az                   = var.vpc_subnet.az
  }
  common = var.common
}
module "natGW" {
  source = "../modules/natgw"
  natgw = {
    subnet_id = module.vpc-subnet.public_subnets_id[0]
  }
  common     = var.common
  depends_on = [module.vpc-subnet]
}

module "route-table" {
  source = "../modules/route-table"
  route_table = {
    cidr_block = var.vpc_subnet.cidr_block
    vpc_id     = module.vpc-subnet.vpc_id[0]
    # The values below are those outputted from the other modules
    gateway_id        = module.vpc-subnet.igw_id[0]
    nat_gateway_id    = module.natGW.ngw_Id[0]
    private_subnet_id = module.vpc-subnet.private_subnets_id[0]
    public_subnet_id  = module.vpc-subnet.public_subnets_id[0]

  }
  common     = var.common
  depends_on = [module.vpc-subnet]
}

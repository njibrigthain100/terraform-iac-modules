######################Creating the vpc#######################################################
resource "aws_vpc" "account" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-VPC"
    }
  )

}

######################Creating the internet gateway###############################################
resource "aws_internet_gateway" "account_igw" {
  vpc_id = aws_vpc.account.id

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-igw"
    }
  )

}

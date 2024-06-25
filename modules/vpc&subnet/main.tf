######################Creating the vpc#######################################################
resource "aws_vpc" "account" {
  cidr_block           = var.vpc_subnet.cidr_block
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


resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.account.id
  # The for_each argument here iterates over the az and subnet and sets their values and sets theindex(idx) as the key
  for_each          = { for idx, az in var.vpc_subnet.az : idx => { az = az, cidr = var.vpc_subnet.private_subnets_cidr[idx] } }
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Private-Subnet-${each.key + 1}"
    }
  )
}
############################Creating the public subnets#############################################
resource "aws_subnet" "public_subnet" {
  vpc_id =aws_vpc.account.id
  # The for_each argument here iterates over the az and subnet and sets their values and sets theindex(idx) as the key
  for_each                = { for idx, az in var.vpc_subnet.az : idx => { az = az, cidr = var.vpc_subnet.public_subnets_cidr[idx] } }
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true 

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Public-Subnet-${each.key + 1}"
    }
  )
}

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


resource "aws_subnet" "account_private_subnet" {
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
resource "aws_subnet" "account_public_subnet" {
  vpc_id = aws_vpc.account.id
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

#######################Creating an eip for nat gateway############################################
resource "aws_eip" "account_eip" {
  for_each = aws_subnet.account_public_subnet
  domain   = "vpc"
  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-eip-${each.key + 1}"
    }
  )

}

#####################Creating the nat gateway######################################################
resource "aws_nat_gateway" "account_nat_gw" {
  for_each      = aws_subnet.account_public_subnet
  subnet_id     = each.value.id
  allocation_id = aws_eip.account_eip[each.key].id
  depends_on = [
    aws_subnet.account_public_subnet,
    aws_eip.account_eip
  ]

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-nat_gw-${each.key + 1}"
    }
  )
}

#########################Creating the private route table#############################################
resource "aws_route_table" "account_private_rt" {
  for_each = aws_subnet.account_private_subnet
  vpc_id = aws_vpc.account.id

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Private-rt-${each.key + 1}"
    }
  )
}
############################Creating private route##################################################### 

resource "aws_route" "account_private_route" {
  for_each = aws_subnet.account_private_subnet
  route_table_id         = aws_route_table.account_private_rt[each.key].id 
  gateway_id             = aws_nat_gateway.account_nat_gw[each.key].id
  destination_cidr_block = "0.0.0.0/0"

}

###########################Creating the public route table############################################## 
resource "aws_route_table" "account_public_rt" {
  for_each = aws_subnet.account_public_subnet
  vpc_id = aws_vpc.account.id

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Public-rt-${each.key + 1}"
    }
  )
}

##########################Creating the public route##################################################### 

resource "aws_route" "account_public_route" {
  for_each = aws_subnet.account_public_subnet
  route_table_id         = aws_route_table.account_public_rt[each.key].id
  gateway_id             = aws_internet_gateway.account_igw.id 
  destination_cidr_block = "0.0.0.0/0"

}
###########################Creating private route table association##################################### 
resource "aws_route_table_association" "account_private_rt_association" {
  for_each = aws_subnet.account_private_subnet
  route_table_id = aws_route_table.account_private_rt[each.key].id
  subnet_id      = aws_subnet.account_private_subnet[each.key].id 

}

############################Creating public route table association####################################### 
resource "aws_route_table_association" "account_public_rt_association" {
  for_each = aws_subnet.account_public_subnet
  route_table_id = aws_route_table.account_public_rt[each.key].id
  subnet_id      = aws_subnet.account_public_subnet[each.key].id 

}


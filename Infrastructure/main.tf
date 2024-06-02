locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service      = var.Service
    Owner        = var.Owner
    Environment  = var.Environment
    Tier         = var.Tier
    Build-Method = var.Build-Method
    CostCenter   = var.CostCenter
    Complaince   = var.Compliance

  }
}
######################Creating the vpc#######################################################
resource "aws_vpc" "customer-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-VPC"
    }
  )

}
######################Creating the internet gateway###############################################
resource "aws_internet_gateway" "customer-igw" {
  vpc_id = aws_vpc.customer-vpc.id

  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-igw"
    }
  )

}
#######################Creating an eip for nat gateway############################################
resource "aws_eip" "customer-eip" {
  domain = "vpc"
  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-eip"
    }
  )

}

#####################Creating the nat gateway######################################################
resource "aws_nat_gateway" "customer-nat_gw" {
  # The 0 in the below code means that we are allocating the nat gateway only to the first subnet
  subnet_id     = element(aws_subnet.customer-public-subnets.*.id, 0)
  allocation_id = aws_eip.customer-eip.id
  # The dependency here is important as the nat gateway is depended on the public subnet
  # And the elastic ip. So these resources have to be created first before the ngw
  depends_on = [
    aws_subnet.customer-public-subnets,
    aws_eip.customer-eip
  ]

  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-nat_gw"
    }
  )
}
#####################Creating the private subnets##################################################
resource "aws_subnet" "customer-private-subnets" {
  vpc_id            = aws_vpc.customer-vpc.id
  availability_zone = element(var.private_az, count.index)
  # availability_zone = var.private_az[count.index]
  count      = length(var.private_subnets_cidr)
  cidr_block = element(var.private_subnets_cidr, count.index)
  # cidr_block = var.private_subnets_cidr[count.index]

  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-Private-Subnet-${count.index + 1}"
    }
  )

}
############################Creating the public subnets#############################################
resource "aws_subnet" "customer-public-subnets" {
  vpc_id            = aws_vpc.customer-vpc.id
  availability_zone = element(var.public_az, count.index)
  # availability_zone = var.public_az[count.index]
  count = length(var.public_subnets_cidr)
  # For the cidr block or az you can also use the element function as shown below
  cidr_block = element(var.public_subnets_cidr, count.index)
  #cidr_block = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-Public-Subnet-${count.index + 1}"
    }
  )

}
###########################Creating the private route table#############################################
resource "aws_route_table" "customer-private-rt" {
  vpc_id = aws_vpc.customer-vpc.id

  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-Private-rt"
    }
  )
}

############################Creating private route##################################################### 

resource "aws_route" "customer-private-route" {
  route_table_id         = aws_route_table.customer-private-rt.id
  gateway_id             = aws_nat_gateway.customer-nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_nat_gateway.customer-nat_gw
  ]

}
###########################Creating the public route table############################################## 
resource "aws_route_table" "customer-public-rt" {
  vpc_id = aws_vpc.customer-vpc.id

  tags = merge(local.common_tags,
    {
      "Name" = "${var.Owner}-${var.Environment}-Public-rt"
    }
  )
}

##########################Creating the public route##################################################### 

resource "aws_route" "customer-public-route" {
  route_table_id         = aws_route_table.customer-public-rt.id
  gateway_id             = aws_internet_gateway.customer-igw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_internet_gateway.customer-igw
  ]

}
###########################Creating private route table association##################################### 
resource "aws_route_table_association" "customer-private-rt-association" {
  count          = length(var.private_subnets_cidr)
  route_table_id = aws_route_table.customer-private-rt.id
  subnet_id      = element(aws_subnet.customer-private-subnets.*.id, count.index)

}

############################Creating public route table association####################################### 
resource "aws_route_table_association" "customer-public-rt-association" {
  count          = length(var.public_subnets_cidr)
  route_table_id = aws_route_table.customer-public-rt.id
  subnet_id      = element(aws_subnet.customer-public-subnets.*.id, count.index)

}
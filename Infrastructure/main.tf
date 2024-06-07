######################Creating the vpc#######################################################
resource "aws_vpc" "customer-vpc" {
  cidr_block           = var.vpc_specific[0].cidr_block
  enable_dns_hostnames = true

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-VPC"
    }
  )

}
######################Creating the internet gateway###############################################
resource "aws_internet_gateway" "customer-igw" {
  vpc_id = aws_vpc.customer-vpc.id

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-igw"
    }
  )

}
#######################Creating an eip for nat gateway############################################
resource "aws_eip" "customer-eip" {
  domain = "vpc"
  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-eip"
    }
  )

}

#####################Creating the nat gateway######################################################
resource "aws_nat_gateway" "customer-nat_gw" {
  # The 0 in the below code means that we are allocating the nat gateway only to the first subnet
  subnet_id     = aws_subnet.customer-public-subnets[0].id
  allocation_id = aws_eip.customer-eip.id
  # The dependency here is important as the nat gateway is depended on the public subnet
  # And the elastic ip. So these resources have to be created first before the ngw
  depends_on = [
    aws_subnet.customer-public-subnets,
    aws_eip.customer-eip
  ]

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-nat_gw"
    }
  )
}
#####################Creating the private subnets##################################################
resource "aws_subnet" "customer-private-subnets" {
  vpc_id = aws_vpc.customer-vpc.id
  # The for_each argument here allows terraform to iterate over the azs and maps them as the value and the subnets as the key
  for_each          = { for idx, az in var.vpc_specific[0].private_az : idx => az }
  availability_zone = each.value
  cidr_block        = var.vpc_specific[0].private_subnets_cidr[each.key]
  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Private-Subnet-${each.key}"
    }
  )

}
############################Creating the public subnets#############################################
resource "aws_subnet" "customer-public-subnets" {
  vpc_id = aws_vpc.customer-vpc.id
  # The for_each argument here allows terraform to iterate over the azs and maps them as the value and the subnets as the key  
  for_each                = { for idx, az in var.vpc_specific[0].public_az : idx => az }
  availability_zone       = each.value
  cidr_block              = var.vpc_specific[0].public_subnets_cidr[each.key]
  map_public_ip_on_launch = true

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Public-Subnet-${each.key}"
    }
  )

}
###########################Creating the private route table#############################################
resource "aws_route_table" "customer-private-rt" {
  vpc_id = aws_vpc.customer-vpc.id

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Private-rt"
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

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Public-rt"
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
  for_each       = { for idx, subnet in aws_subnet.customer-private-subnets : idx => subnet.id }
  route_table_id = aws_route_table.customer-private-rt.id
  subnet_id      = each.value

}

############################Creating public route table association####################################### 
resource "aws_route_table_association" "customer-public-rt-association" {
  for_each       = { for idx, subnet in aws_subnet.customer-public-subnets : idx => subnet.id }
  route_table_id = aws_route_table.customer-public-rt.id
  subnet_id      = each.value

}

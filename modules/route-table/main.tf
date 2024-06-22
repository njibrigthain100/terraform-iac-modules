#########################Creating the private route table#############################################
resource "aws_route_table" "account-private-rt" {
  vpc_id = var.route_table.vpc_id

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Private-rt"
    }
  )
}

############################Creating private route##################################################### 

resource "aws_route" "account-private-route" {
  route_table_id         = aws_route_table.account-private-rt.id
  gateway_id             = var.route_table.nat_gateway_id
  destination_cidr_block = "0.0.0.0/0"

}
###########################Creating the public route table############################################## 
resource "aws_route_table" "account-public-rt" {
  vpc_id = var.route_table.vpc_id

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Public-rt"
    }
  )
}

##########################Creating the public route##################################################### 

resource "aws_route" "account-public-route" {
  route_table_id         = aws_route_table.account-public-rt.id
  gateway_id             = var.route_table.gateway_id
  destination_cidr_block = "0.0.0.0/0"

}
###########################Creating private route table association##################################### 
resource "aws_route_table_association" "account-private-rt-association" {
  #for_each       = { for idx, subnet in aws_subnet.account-private-subnets : idx => subnet.id }
  route_table_id = aws_route_table.account-private-rt.id
  subnet_id      = var.route_table.private_subnet_id

}

############################Creating public route table association####################################### 
resource "aws_route_table_association" "account-public-rt-association" {
  #for_each       = { for idx, subnet in aws_subnet.account-public-subnets : idx => subnet.id }
  route_table_id = aws_route_table.account-public-rt.id
  subnet_id      = var.route_table.public_subnet_id

}

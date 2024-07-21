output "vpc_Id" {
  description = "The id of the vpc"
  value = aws_vpc.account.id 
}

output "Public_subnet_ids" {
  description = "The id of the public subnets"
  value = { for key, subnet in aws_subnet.account_public_subnet : key => subnet.id }
}

output "Private_subnet_ids" {
  description = "The id of the private subnets"
  value = { for key, subnet in aws_subnet.account_private_subnet : key => subnet.id }
}

output "natgateway_id" {
  description = "The id of the nat gateways"
  value = { for key, nat in aws_nat_gateway.account_nat_gw : key => nat.id }
}

output "internetgw_id" {
  description = "The id of the internet gateways"
  value = [aws_internet_gateway.account_igw.id]
}

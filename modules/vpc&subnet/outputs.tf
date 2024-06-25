output "vpc_id" {
  description = "The id of the vpc"
  value       = [aws_vpc.account.id]
}

output "igw_id" {
  description = "The value of the internet gateway"
  value      = [ aws_internet_gateway.account_igw.id]
}
output "private_subnets_id" {
  description = "The id of the private subnet"
  value = [ for subnet in aws_subnet.private_subnet : subnet.id ]
}

output "public_subnets_id" {
  description = "The id of the private subnet"
  value = [ for subnet in aws_subnet.public_subnet : subnet.id ]
}

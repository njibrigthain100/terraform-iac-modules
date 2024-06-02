output "customer-vpc-id" {
  value = [aws_vpc.customer-vpc.id]
}

output "customer-private-subnets-id" {
  value = [aws_subnet.customer-private-subnets.*.id]
}

output "customer-public-subnets-id" {
  value = [aws_subnet.customer-public-subnets.*.id]
}

output "customer-nat-gw-id" {
  value = [aws_nat_gateway.customer-nat_gw.id]
}

output "customer-igw-id" {
  value = [aws_internet_gateway.customer-igw.id]
}
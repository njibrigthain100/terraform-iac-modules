output "customer-vpc-id" {
  description = "the customer vpc id"
  value       = [aws_vpc.customer-vpc.id]
}

output "customer-public-subnets-id" {
  description = "The public subnets id"
  value       = [for subnet in aws_subnet.customer-public-subnets : subnet.id]
}

output "customer-private-subnets-id" {
  description = "The public subnets id"
  value       = [for subnet in aws_subnet.customer-private-subnets : subnet.id]
}

output "customer-nat-gw-id" {
  description = "The nat gateway id"
  value       = [aws_nat_gateway.customer-nat_gw.id]
}

output "customer-igw-id" {
  description = "The internet gateway id"
  value       = [aws_internet_gateway.customer-igw.id]
}


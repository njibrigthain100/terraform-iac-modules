output "private_subnets_id" {
  description = "The id of the private subnet"
  value = [ for subnet in aws_subnet.private_subnet : subnet.id ]
}

output "public_subnets_id" {
  description = "The id of the private subnet"
  value = [ for subnet in aws_subnet.public_subnet : subnet.id ]
}
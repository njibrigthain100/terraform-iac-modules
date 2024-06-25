output "vpc_id" {
  description = "The id of the vpc"
  value = [ module.vpc-subnet.vpc_id ]
}
output "igw_id" {
  description = "The value of the internet gateway"
  value      = [ module.vpc-subnet.igw_id ]
}

output "private_subnet_id" {
  description = "The id of the private subnet"
  value = [ module.vpc-subnet.private_subnets_id ]
}

output "public_subnet_id" {
  description = "The id of the private subnet"
  value = [ module.vpc-subnet.public_subnets_id ]
}
output "vpc_id" {
  description = "The id of the vpc"
  value = [ module.vpc.vpc_id ]
}

output "private_subnet_id" {
  description = "The id of the private subnet"
  value = [ module.subnets.private_subnets_id ]
}

output "public_subnet_id" {
  description = "The id of the private subnet"
  value = [ module.subnets.public_subnets_id ]
}
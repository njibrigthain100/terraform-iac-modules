output "vpc_id" {
  description = "The id of the vpc"
  value       = [aws_vpc.account.id]
}

output "igw_id" {
  description = "The value of the internet gateway"
  value      = [ aws_internet_gateway.account_igw.id]
}

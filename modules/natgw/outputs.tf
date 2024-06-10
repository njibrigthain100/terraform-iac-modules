output "ng_public_ip" {
  description = "The public ip of the natgatway"
  value = [ aws_nat_gateway.account-nat_gw.public_ip ]
}
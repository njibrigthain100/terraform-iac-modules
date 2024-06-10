#######################Creating an eip for nat gateway############################################
resource "aws_eip" "account-eip" {
  domain = "vpc"
  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-eip"
    }
  )

}

#####################Creating the nat gateway######################################################
resource "aws_nat_gateway" "account-nat_gw" {
  # The 0 in the below code means that we are allocating the nat gateway only to the first subnet
  subnet_id     = var.vpc.subnet_id
  allocation_id = aws_eip.account-eip.id
  # The dependency here is important as the nat gateway is depended on the public subnet
  # And the elastic ip. So these resources have to be created first before the ngw
  depends_on = [
    aws_eip.account-eip
  ]

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-nat_gw"
    }
  )
}
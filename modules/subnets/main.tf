#####################Creating the subnets##################################################
resource "aws_subnet" "private_subnet" {
  vpc_id = var.vpc.vpc_id
  # The for_each argument here iterates over the az and subnet and sets their values and sets theindex(idx) as the key
  for_each          = { for idx, az in var.vpc.az : idx => { az = az, cidr = var.vpc.private_subnets_cidr[idx] } }
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Private-Subnet-${each.key + 1}"
    }
  )
}
############################Creating the public subnets#############################################
resource "aws_subnet" "public_subnet" {
  vpc_id = var.vpc.vpc_id
  # The for_each argument here iterates over the az and subnet and sets their values and sets theindex(idx) as the key
  for_each                = { for idx, az in var.vpc.az : idx => { az = az, cidr = var.vpc.public_subnets_cidr[idx] } }
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = merge(var.common,
    {
      "Name" = "${var.common.Owner}-${var.common.Environment}-Public-Subnet-${each.key + 1}"
    }
  )
}


#------------------------------------------------
# Common variables
#------------------------------------------------
variable "common" {
  description = "These are the common variables used by all resources"
  type = object({
    Environment      = string
    Service          = string
    Owner            = string
    Tier             = string
    Build-Method     = string
    CostCenter       = string
    Compliance       = string
    instance-profile = string
  })
}

#--------------------------------------------------
#vpc specific variables
#--------------------------------------------------
variable "vpc_specific" {
  description = "vpc specific variables for each account"
  type = object({
    cidr_block           = string
    region_name          = string
    private_subnets_cidr = list(string)
    public_subnets_cidr  = list(string)
    private_az           = list(string)
    public_az            = list(string)
  })
}

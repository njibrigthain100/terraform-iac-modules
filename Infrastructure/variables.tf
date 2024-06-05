#------------------------------------------------
# Common variables
#------------------------------------------------
variable "common" {
  description = "These are the common variables used by all resources"
  type = list(object({
    Environment      = string
    Service          = string
    Owner            = string
    Tier             = string
    Build-Method     = string
    CostCenter       = string
    Compliance       = string
    instance-profile = string

  }))
}

#--------------------------------------------------
#vpc specific variables
#--------------------------------------------------
variable "vpc_specific" {
  description = "vpc specific variables for each account"
  type = list(object({
    cidr_block           = string
    region_name          = string
    private_subnets_cidr = string
    public_subnets_cidr  = string
    private_az           = string
    public_az            = string
    vpc_id               = optional(string)
    private_subnet_id    = optional(string)
    public_subnet_id     = optional(string)
    natgw_id             = optional(string)
    igw_id               = optional(string)            = optional(string)
  }))
}

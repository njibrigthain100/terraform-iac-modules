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
  default = null
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
    vpc_id               = optional(string)
    private_subnet_id    = optional(string)
    public_subnet_id     = optional(string)
    natgw_id             = optional(string)
    igw_id               = optional(string)            
  })
  default = null
}

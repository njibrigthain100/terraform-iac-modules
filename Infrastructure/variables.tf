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
  type = list(object({
    cidr_block           = number
    region_name          = string
    private_subnets_cidr = list(number)
    public_subnets_cidr  = list(number)
    private_az           = list(string)
    public_az            = list(string)
  }))
  default = null
}

variable "vpc_items" {
  
}

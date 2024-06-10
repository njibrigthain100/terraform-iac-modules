#------------------------------------------------
# Common variables
#------------------------------------------------
variable "common" {
  description = "These are the common variables used by all resources"
  type = object({
    Environment  = string
    Service      = string
    Owner        = string
    Tier         = optional(string)
    Build-Method = string
    CostCenter   = string
    Compliance   = string
  })
  default = null
}

#--------------------------------------------------
#vpc specific variables
#--------------------------------------------------
variable "vpc" {
  description = "vpc specific variables for each account"
  type = object({
    cidr_block           = string
    private_subnets_cidr = list(string)
    public_subnets_cidr  = list(string)
    az                   = list(string)
    vpc_id               = optional(string)
    subnet_id            = optional(string)
  })
  default = null
}


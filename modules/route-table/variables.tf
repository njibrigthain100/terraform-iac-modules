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


variable "vpc" {
  description = "vpc specific variables for each account"
  type = object({
    cidr_block = string 
    vpc_id = optional(string)
  })
  default = null
}

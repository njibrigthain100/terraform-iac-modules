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

variable "natgw" {
  description = "vpc specific variables for each account"
  type = object({
    subnet_id            = optional(string)
  })
  default = null
}



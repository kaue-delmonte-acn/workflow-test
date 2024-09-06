########################################################################################################################
## Service variables
########################################################################################################################

variable "namespace" {
  description = "Namespace for resource names"
  type        = string
}

variable "environment" {
  description = "Environment for deployment (like prd or hml)"
  type        = string
}

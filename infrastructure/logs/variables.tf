########################################################################################################################
## Service variables
########################################################################################################################

variable "namespace" {
  description = "Namespace for resource names"
}

variable "environment" {
  description = "Environment for deployment (like prd or hml)"
  default     = "hml"
  type        = string
}

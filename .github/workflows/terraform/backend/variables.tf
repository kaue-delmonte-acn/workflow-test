########################################################################################################################
## AWS config
########################################################################################################################

variable "aws_profile" {
  description = "AWS profile"
  default     = "data-portal-prd"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

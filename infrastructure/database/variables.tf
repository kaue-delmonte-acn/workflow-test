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

########################################################################################################################
## Database variables
########################################################################################################################

variable "rds_username" {
  description = "RDS username"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "RDS password"
  type        = string
  sensitive   = true

}

variable "rds_db_name" {
  description = "Database name"
  type        = string
  sensitive   = true
}

variable "rds_db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "rds_db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

########################################################################################################################
## Network variables
########################################################################################################################

variable "database_subnets" {
  description = "List of Database Subnets ids"
  type        = list(string)
}

variable "rds_security_group" {
  description = "Database Security Group"
  type        = string
}

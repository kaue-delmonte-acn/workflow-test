########################################################################################################################
## Service variables
########################################################################################################################

variable "namespace" {
  description = "Namespace for resource names"
  default     = "ckan"
  type        = string
}

variable "environment" {
  description = "Environment for deployment (like prd or hml)"
  default     = "prd"
  type        = string
}

########################################################################################################################
## AWS config
########################################################################################################################

variable "aws_profile" {
  description = "AWS profile"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

########################################################################################################################
## EC2 Computing variables
########################################################################################################################

variable "public_ec2_key" {
  description = "Public key for SSH access to EC2 instances"
  type        = string
}

########################################################################################################################
## EC2 Computing variables
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

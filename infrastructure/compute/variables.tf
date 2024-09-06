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
## Network variables
########################################################################################################################

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "public_subnets" {
  description = "List of Public Subnets ids"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of Private Subnets ids"
  type        = list(string)
}

variable "ec2_security_group" {
  description = "EC2 Instance Security Group"
  type        = string
}

variable "alb_security_group" {
  description = "Load Balancer Security Group"
  type        = string
}

variable "bastion_security_group" {
  description = "Bastion Instance Security Group"
  type        = string
}
########################################################################################################################
## Compute variables
########################################################################################################################

variable "ec2_profile" {
  description = "EC2 instance IAM profile ARN"
  type        = string
}

variable "public_ec2_key" {
  description = "Public key for SSH access to EC2 instances"
  type        = string
}

########################################################################################################################
## Cluster variables
########################################################################################################################

variable "ecs_cluster" {
  description = "ECS cluster name"
  type        = string
}

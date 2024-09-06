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
## AWS variables
########################################################################################################################

variable "aws_region" {
  description = "AWS region"
  type        = string
}

########################################################################################################################
## Compute variables
########################################################################################################################

variable "autoscaling_group" {
  description = "Auto Scaling Group ARN"
  type        = string
}

variable "alb_target_group" {
  description = "Load Balancer Target Group ARN"
  type        = string
}

########################################################################################################################
## Role variables
########################################################################################################################

variable "ecs_service_role" {
  description = "IAM Role ARN for ECS Service"
  type        = string
}

variable "ecs_task_role" {
  description = "IAM Role ARN for ECS Tasks"
  type        = string
}

variable "ecs_task_execution_role" {
  description = "IAM Role ARN for ECS Task Execution"
  type        = string
}

########################################################################################################################
## Logs variables
########################################################################################################################

variable "log_group" {
  description = "Log Group for ECS Services"
  type        = string
}


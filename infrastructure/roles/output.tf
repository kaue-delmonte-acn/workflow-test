########################################################################################################################
## Roles output
########################################################################################################################

output "ec2_profile" {
  description = "EC2 instance IAM profile ARN"
  value       = aws_iam_instance_profile.ec2_instance.arn
}

output "ecs_service_role" {
  description = "IAM Role ARN for ECS Service"
  value       = aws_iam_role.ecs_service.arn
}

output "ecs_task_role" {
  description = "IAM Role ARN for ECS Tasks"
  value       = aws_iam_role.ecs_task.arn
}

output "ecs_task_execution_role" {
  description = "IAM Role ARN for ECS Task Execution"
  value       = aws_iam_role.ecs_task_execution.arn
}

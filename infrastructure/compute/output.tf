########################################################################################################################
## Compute output
########################################################################################################################

output "autoscaling_group" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.default.arn
}

output "alb_target_group" {
  description = "Load Balancer Target Group ARN"
  value       = aws_alb_target_group.default.arn
}

output "alb_dns" {
  value = aws_alb.default.dns_name
}

########################################################################################################################
## Create log group for ECS service
########################################################################################################################

resource "aws_cloudwatch_log_group" "default" {
  name              = "/${lower(var.namespace)}/ecs/${var.environment}"
  retention_in_days = 7

  tags = {
    Environment = var.environment
  }
}

########################################################################################################################
## Creates Capacity Provider linked with ASG and ECS Cluster
########################################################################################################################

resource "aws_ecs_capacity_provider" "default" {
  name = "${var.namespace}-ecs-capacity-provider-${var.environment}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.autoscaling_group
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 4
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_cluster_capacity_providers" "default" {
  cluster_name       = aws_ecs_cluster.default.name
  capacity_providers = [aws_ecs_capacity_provider.default.name]
}

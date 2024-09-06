########################################################################################################################
## Creates ECS Service
########################################################################################################################

resource "aws_ecs_service" "service" {
  name                               = "${var.namespace}-ecs-service-${var.environment}"
  iam_role                           = var.ecs_service_role
  cluster                            = aws_ecs_cluster.default.id
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100

  load_balancer {
    target_group_arn = var.alb_target_group
    container_name   = "${var.namespace}-container-${var.environment}"
    container_port   = 80 # var.container_port
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = {
    Environment = var.environment
  }
}

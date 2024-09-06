########################################################################################################################
## Creates ECS Task Definition
########################################################################################################################

resource "aws_ecs_task_definition" "default" {
  family             = "${var.namespace}-ecs-task-definition-${var.environment}"
  execution_role_arn = var.ecs_task_execution_role
  task_role_arn      = var.ecs_task_role

  container_definitions = jsonencode([
    {
      name : "ckan-container-${var.environment}"
      image : "ckan/ckan-base:2.11"
      cpu : 1024,
      memory : 4096
      essential = true
      portMappings = [
        {
          containerPort = 5000 # var.container_port
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = var.log_group
          "awslogs-region"        = var.aws_region,
          "awslogs-stream-prefix" = "app"
        }
      }
    },
    {
      name : "solr-container-${var.environment}"
      image : "ckan/ckan-solr:2.11-solr9"
      cpu : 512,
      memory : 2048
      essential = true
      portMappings = [
        {
          containerPort = 8983
          hostPort      = 8983
          protocol      = "tcp"
        }
      ]
    },
    {
      name : "redis-container-${var.environment}"
      image : "redis:6"
      cpu : 128,
      memory : 512
      essential = true
      portMappings = [
        {
          containerPort = 6379
          hostPort      = 6379
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Environment = var.environment
  }
}

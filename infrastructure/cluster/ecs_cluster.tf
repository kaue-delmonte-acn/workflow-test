########################################################################################################################
## Creates an ECS Cluster
########################################################################################################################

resource "aws_ecs_cluster" "default" {
  name = "${var.namespace}-ecs-cluster-${var.environment}"

  tags = {
    Name        = "${var.namespace}-ecs-cluster-${var.environment}"
    Environment = var.environment
  }
}

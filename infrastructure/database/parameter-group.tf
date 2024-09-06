resource "aws_db_parameter_group" "default" {
  name   = "${var.namespace}-database"
  family = "postgres16"

  tags = {
    Name        = "${var.namespace}-db-parameter-group-${var.environment}"
    Environment = var.environment
  }
}

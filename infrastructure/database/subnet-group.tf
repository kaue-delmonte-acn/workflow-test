resource "aws_db_subnet_group" "default" {
  name       = "${var.namespace}-db-subnet-group-${var.environment}"
  subnet_ids = var.database_subnets

  tags = {
    Name        = "${var.namespace}-db-subnet-group-${var.environment}"
    Environment = var.environment
  }
}

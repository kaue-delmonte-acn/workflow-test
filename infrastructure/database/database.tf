resource "aws_db_instance" "default" {
  engine                              = "postgres"
  engine_version                      = "16"
  instance_class                      = "db.t4g.medium"
  backup_retention_period             = 7
  allocated_storage                   = 32
  port                                = 5432
  apply_immediately                   = true
  storage_encrypted                   = true
  deletion_protection                 = true
  performance_insights_enabled        = true
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true
  username                            = var.rds_username
  password                            = var.rds_password
  db_subnet_group_name                = aws_db_subnet_group.default.name
  kms_key_id                          = aws_kms_key.default.arn
  performance_insights_kms_key_id     = aws_kms_key.perfomance_insight.arn
  parameter_group_name                = aws_db_parameter_group.default.name
  vpc_security_group_ids              = [var.rds_security_group]

  tags = {
    Name        = "${var.namespace}-database-${var.environment}"
    Environment = var.environment
  }
}

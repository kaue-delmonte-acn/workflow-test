resource "aws_kms_key" "default" {
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name        = "${var.namespace}-db-kms-key-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_kms_key" "perfomance_insight" {
  enable_key_rotation = true

  tags = {
    Name        = "${var.namespace}-db-performance-insight-key-${var.environment}"
    Environment = var.environment
  }
}

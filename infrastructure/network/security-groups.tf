########################################################################################################################
## Security Group for EC2 instances
########################################################################################################################

resource "aws_security_group" "ec2" {
  name        = "${var.namespace}-ec2-instance-security-group-${var.environment}"
  description = "Security group for EC2 instances in ECS cluster"
  vpc_id      = aws_vpc.default.id

  ingress {
    description     = "Allow ingress traffic from ALB on HTTP on ephemeral ports"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "Allow SSH ingress traffic from bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic to connect to the Postgres database"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  tags = {
    Name        = "${var.namespace}-ec2-instance-security-group-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Security Group for ALB
########################################################################################################################

resource "aws_security_group" "alb" {
  name        = "${var.namespace}-alb-security-group-${var.environment}"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Allow ingress traffic on HTTP port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}-alb-security-group-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Security Group for RDS
########################################################################################################################

resource "aws_security_group" "rds" {
  description = "Allow connections to the database"
  vpc_id      = aws_vpc.default.id

  ingress {
    description     = "Allow inbound traffic on Postgres default port"
    security_groups = [aws_security_group.ec2.id]
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
  }

  tags = {
    Name        = "${var.namespace}-rds-instance-security-group-${var.environment}"
    Environment = var.environment
  }
}


########################################################################################################################
## Security Group for Bastion Host
########################################################################################################################

resource "aws_security_group" "bastion" {
  name        = "${var.namespace}-security-group-bastion-host-${var.environment}"
  description = "Bastion Host Security Group"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

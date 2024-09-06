########################################################################################################################
## Create VPC with a CIDR block that has enough capacity for the amount of DNS names needed
########################################################################################################################

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.namespace}-vpc-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Create Internet Gateway for egress/ingress connections to resources in the public subnets
########################################################################################################################

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name        = "${var.namespace}-internet-gateway-${var.environment}"
    Environment = var.environment
  }
}

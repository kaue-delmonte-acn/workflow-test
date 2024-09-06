########################################################################################################################
## How many subnets will be created per type, i.e subnets_count = 2 -> 2 public, 2 private, 2 database, total 6 subnets
########################################################################################################################

locals {
  subnets_count = 2
}

########################################################################################################################
## This resource returns a list of all AZ available in the region configured in the AWS credentials
########################################################################################################################

data "aws_availability_zones" "available" {}

########################################################################################################################
## Public Subnets (one per AZ)
########################################################################################################################

resource "aws_subnet" "public" {
  count                   = local.subnets_count
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, local.subnets_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.namespace}-public-subnet-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Route Table with egress route to the internet
########################################################################################################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.namespace}-public-route-table-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Associate Route Table with Public Subnets
########################################################################################################################

resource "aws_route_table_association" "public" {
  count          = local.subnets_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

########################################################################################################################
## Creates one Elastic IP per AZ (one for each NAT Gateway in each AZ)
########################################################################################################################

resource "aws_eip" "nat_gateway" {
  count  = local.subnets_count
  domain = "vpc"

  tags = {
    Name        = "${var.namespace}-eip-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Creates one NAT Gateway per AZ
########################################################################################################################

resource "aws_nat_gateway" "nat_gateway" {
  count         = local.subnets_count
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_gateway[count.index].id

  tags = {
    Name        = "${var.namespace}-nat-gateway-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Private Subnets (one per AZ)
########################################################################################################################

resource "aws_subnet" "private" {
  count             = local.subnets_count
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.default.id

  tags = {
    Name        = "${var.namespace}-private-subnet-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Route to the internet using the NAT Gateway
########################################################################################################################

resource "aws_route_table" "private" {
  count  = local.subnets_count
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name        = "${var.namespace}-private-route-table-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

########################################################################################################################
## Associate Route Table with Private Subnets
########################################################################################################################

resource "aws_route_table_association" "private" {
  count          = local.subnets_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

########################################################################################################################
## Database Subnets (one per AZ)
########################################################################################################################

resource "aws_subnet" "database" {
  count             = local.subnets_count
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, local.subnets_count + 2 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.default.id

  tags = {
    Name        = "${var.namespace}-database-subnet-${count.index + 1}-${var.environment}"
    Environment = var.environment
  }
}

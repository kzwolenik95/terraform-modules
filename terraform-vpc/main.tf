resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = merge(var.tags, { "Name" = var.vpc_name })
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-public-${count.index}" })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-private-${count.index}" })
}

locals {
  has_public_subnets = length(var.public_subnets) > 0 ? true : false
}

resource "aws_internet_gateway" "this" {
  count  = local.has_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-igw" })
}

resource "aws_route_table" "public" {
  count  = local.has_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_eip" "nat" {
  count  = local.has_public_subnets ? 1 : 0
  domain = "vpc"

  tags = merge(var.tags, { "name" = "${var.vpc_name}-nat-eip" })
}

resource "aws_nat_gateway" "this" {
  count         = local.has_public_subnets && var.use_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, { "name" = "${var.vpc_name}-nat-gw" })
}

module "fck-nat" {
  count  = local.has_public_subnets && !var.use_nat_gateway ? 1 : 0
  source = "RaJiska/fck-nat/aws"

  name                 = "${var.vpc_name}-fck-nat"
  vpc_id               = aws_vpc.this.id
  subnet_id            = aws_subnet.public[0].id
  eip_allocation_ids   = [aws_eip.nat[0].id]
  use_cloudwatch_agent = true
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-private-rt" })
}

resource "aws_route" "nat" {
  count                  = local.has_public_subnets ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.use_nat_gateway ? aws_nat_gateway.this[0].id : null
  network_interface_id   = var.use_nat_gateway ? null : module.fck-nat[0].eni_id
}


resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

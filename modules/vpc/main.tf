resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    "Name" = "${var.prefix_name}-vpc"
  })
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.subnet_cidr_blocks_public)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr_blocks_public[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    "Name"                                      = "${var.prefix_name}-public-subnet-${count.index + 1}",
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.subnet_cidr_blocks_private)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.subnet_cidr_blocks_private[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = merge(var.tags, {
    "Name"                                      = "${var.prefix_name}-private-subnet-${count.index + 1}",
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_eip" "nat_ip" {
  tags = merge(var.tags, { "Name" = "${var.prefix_name}-nat-ip" })
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.tags, { "Name" = "${var.prefix_name}-igw" })

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_nat_gateway" "main_nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags          = merge(var.tags, { "Name" = "${var.prefix_name}-nat-gateway" })

  depends_on = [aws_eip.nat_ip, aws_subnet.public_subnet]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.tags, { "Name" = "${var.prefix_name}-public-route-table" })

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.tags, { "Name" = "${var.prefix_name}-private-route-table" })

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = [aws_subnet.public_subnet, aws_route_table.public_route_table]
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id

  depends_on = [aws_subnet.private_subnet, aws_route_table.private_route_table]
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id

  depends_on = [aws_route_table.public_route_table, aws_internet_gateway.main_igw]
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_nat_gateway.id

  lifecycle {
    ignore_changes = [destination_cidr_block, nat_gateway_id]
  }

  depends_on = [aws_route_table.private_route_table, aws_nat_gateway.main_nat_gateway]
}
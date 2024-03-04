data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = "${var.name}-test-vpc",
      Environment = var.environment
    } 
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "${var.name}-igw",
      Environment = var.environment
    }
  )
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  count                   = length(var.public_subnet_cidr_blocks)
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    {
      Name        = "${var.name}-public-subnet",
      Environment = var.environment
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[1]
 tags = merge(
    {
      Name        = "${var.name}-private-subnet",
      Environment = var.environment
    }
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table_association.public]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    {
      Name        = "${var.name}-public-RT",
      Environment = var.environment
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}

resource "aws_eip" "nat" {
  domain = "vpc"
}
resource "aws_nat_gateway" "ngw_id" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name        = "${var.name}-private-RT",
      Environment = var.environment
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_id.id
  depends_on             = [aws_route_table_association.private]
}



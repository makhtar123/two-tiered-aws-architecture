resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_sub1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "public-sub1"
  }
}

resource "aws_subnet" "public_sub2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "public-sub2"
  }
}

resource "aws_subnet" "private_sub1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zone_1

  tags = {
    Name = "private-sub1"
  }
}

resource "aws_subnet" "private_sub2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zone_2

  tags = {
    Name = "private-sub2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.default_route_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.public_sub2.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_eip" "nat1_eip" {
  domain = "vpc"

  tags = {
    Name = "terraform-nat1-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway1" {
  allocation_id = aws_eip.nat1_eip.id
  subnet_id     = aws_subnet.public_sub1.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "terraform-nat-1"
  }
}

resource "aws_eip" "nat2_eip" {
  domain = "vpc"

  tags = {
    Name = "terraform-nat2-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.nat2_eip.id
  subnet_id     = aws_subnet.public_sub2.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "terraform-nat-2"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = var.default_route_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  tags = {
    Name = "private-route-table-1"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_sub1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = var.default_route_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway2.id
  }

  tags = {
    Name = "private-route-table-2"
  }
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_sub2.id
  route_table_id = aws_route_table.private_2.id
}

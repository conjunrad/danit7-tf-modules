resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name  = "main-vpc"
    Owner = var.owner
  }
}

resource "aws_subnet" "main-public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone_id    = ""
  map_public_ip_on_launch = true

  tags = {
    Name  = "Public subnet"
    Owner = var.owner
  }
}

resource "aws_subnet" "main-private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name  = "Private subnet"
    Owner = var.owner
  }
}

resource "aws_eip" "main-nat-eip" {
  domain = "vpc"

  tags = {
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Owner = var.owner
  }
}

resource "aws_nat_gateway" "main-ngw" {
  allocation_id = aws_eip.main-nat-eip.id
  subnet_id     = aws_subnet.main-public.id

  tags = {
    Owner = var.owner
  }

  depends_on = [aws_internet_gateway.main-igw]
}

resource "aws_route_table" "main-rt-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Owner = var.owner
  }
}

resource "aws_route_table_association" "main-rt-association-public" {
  subnet_id      = aws_subnet.main-public.id
  route_table_id = aws_route_table.main-rt-public.id
}

resource "aws_route_table" "main-rt-private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-ngw.id
  }

  tags = {
    Owner = var.owner
  }
}

resource "aws_route_table_association" "main-rt-association-private" {
  subnet_id      = aws_subnet.main-private.id
  route_table_id = aws_route_table.main-rt-private.id
}

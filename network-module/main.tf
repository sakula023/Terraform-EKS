resource "aws_vpc" "w_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "w_vpc"
  }
}

resource "aws_subnet" "w_public_subnet" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id     = aws_vpc.w_vpc.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  tags = {
    Name = "w_public_subnet${count.index + 1}"
  }
}

resource "aws_subnet" "w_private_subnet" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id     = aws_vpc.w_vpc.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  tags = {
    Name = "w_private_subnet${count.index + 1}"
  }
}

resource "aws_internet_gateway" "w_internetgateway" {
  vpc_id = aws_vpc.w_vpc.id

  tags = {
    Name = "w_internetgateway"
  }
}

resource "aws_route_table" "w_public_route_table" {
  vpc_id = aws_vpc.w_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.w_internetgateway.id
  }
  tags = {
    Name = "w_public_route_table"
  }
}

resource "aws_route_table" "w_private_route_table" {
  vpc_id = aws_vpc.w_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.w_natgateway.id
  }

  tags = {
    Name = "w_private_route_table"
  }
}

resource "aws_route_table_association" "w_private_route_table_association" {
    count = length(var.public_subnet_cidr_blocks)
    subnet_id = aws_subnet.w_private_subnet[count.index].id
    route_table_id = aws_route_table.w_private_route_table.id
}

resource "aws_route_table_association" "w_public_route_table_association" {
    count = length(var.public_subnet_cidr_blocks)
    subnet_id = aws_subnet.w_public_subnet[count.index].id
    route_table_id = aws_route_table.w_public_route_table.id
}

resource "aws_eip" "w_eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.w_internetgateway]
}

resource "aws_nat_gateway" "w_natgateway" {
  subnet_id     = aws_subnet.w_public_subnet[0].id
  allocation_id = aws_eip.w_eip.id

  tags = {
    Name = "w_natgateway"
  }
  depends_on = [aws_internet_gateway.w_internetgateway]
}
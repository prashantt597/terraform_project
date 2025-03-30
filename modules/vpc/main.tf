resource "aws_vpc" "my_vpc" {
  cidr_block = var.aws_vpc
  tags = {
    Name = var.environment
  }
}

resource "aws_subnet" "my_subnet1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.Pub-subnet_cidr-1
  availability_zone = var.avail-zone-pub1
  tags = {
    Name = var.environment
  }
}

resource "aws_subnet" "my_subnet2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.pvt-subnet-cidr-1
  availability_zone = var.avail-zone-pvt1
  tags = {
    Name = var.environment
  }
}

resource "aws_subnet" "my_subnet3" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.Pub-subnet_cidr-2
  availability_zone = var.avail-zone-pub2
  tags = {
    Name = var.environment
  }
}

resource "aws_subnet" "my_subnet4" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.pvt-subnet-cidr-2
  availability_zone = var.avail-zone-pvt2
  tags = {
    Name = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.environment
  }
}

resource "aws_route_table" "My-route-table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.cidr_pub_route
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.environment
  }
}

resource "aws_route_table_association" "route_association1" {
  subnet_id = aws_subnet.my_subnet1.id
  route_table_id = aws_route_table.My-route-table.id
}

resource "aws_route_table_association" "route_association2" {
  subnet_id = aws_subnet.my_subnet3.id
  route_table_id = aws_route_table.My-route-table.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = var.environment
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.my_subnet2.id
  tags = {
    Name = var.environment
  }
}

resource "aws_route_table" "Pvt-route-table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.cidr-pvt-route
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  tags = {
    Name = var.environment
  }
}

resource "aws_route_table_association" "route-association-nat1" {
  subnet_id = aws_subnet.my_subnet4.id
  route_table_id = aws_route_table.Pvt-route-table.id
}

resource "aws_route_table_association" "route-association-nat2" {
  subnet_id = aws_subnet.my_subnet2.id
  route_table_id = aws_route_table.Pvt-route-table.id
}
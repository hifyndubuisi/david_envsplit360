# This file contains the VPC configuration for the primepathcloud project.
# VPC
resource "aws_vpc" "primepath_project_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "primepath vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "primepath_project_igw" {
  vpc_id = aws_vpc.primepath_project_vpc.id

  tags = {
    Name = "primepath igw"
  }
}

# Public subnets
resource "aws_subnet" "primepath_project_public_subnet-az1a" {
  vpc_id                  = aws_vpc.primepath_project_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.primepath_project_vpc,
    aws_internet_gateway.primepath_project_igw,
  ]

  tags = {
    Name = "primepath_project_public_subnet-az1a"
  }
}

resource "aws_subnet" "primepath_project_public_subnet-az1b" {
  vpc_id                  = aws_vpc.primepath_project_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.primepath_project_vpc,
    aws_internet_gateway.primepath_project_igw,
  ]

  tags = {
    Name = "primepath_project_public_subnet-az1b"
  }
}

# Private app subnets
resource "aws_subnet" "primepath_project_private_app_subnet-az1a" {
  vpc_id                  = aws_vpc.primepath_project_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  depends_on = [
    aws_vpc.primepath_project_vpc,
    aws_internet_gateway.primepath_project_igw,
  ]

  tags = {
    Name = "primepath_project_private_app_subnet-az1a"
  }
}

resource "aws_subnet" "primepath_project_private_app_subnet-az1b" {
  vpc_id                  = aws_vpc.primepath_project_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  depends_on = [
    aws_vpc.primepath_project_vpc,
    aws_internet_gateway.primepath_project_igw,
  ]

  tags = {
    Name = "primepath_project_private_app_subnet-az1b"
  }
}

# Private DB subnets
resource "aws_subnet" "primepath_project_private_db_subnet-az1a" {
  vpc_id                  = aws_vpc.primepath_project_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  depends_on = [
    aws_vpc.primepath_project_vpc,
    aws_internet_gateway.primepath_project_igw,
  ]

  tags = {
    Name = "primepath_project_private_db_subnet-az1a"
  }
}

resource "aws_subnet" "primepath_project_private_db_subnet-az1b" {
  vpc_id                  = aws_vpc.primepath_project_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  depends_on = [
    aws_vpc.primepath_project_vpc,
    aws_internet_gateway.primepath_project_igw,
  ]

  tags = {
    Name = "primepath_project_private_db_subnet-az1b"
  }
}

# NAT Gateway EIP
resource "aws_eip" "primepath_nat_gateway_eip-az1a" {
  domain = "vpc"

  tags = {
    Name = "primepath_project_nat_gateway_eip-az1a"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "primepath_nat_gateway-az1a" {
  allocation_id = aws_eip.primepath_nat_gateway_eip-az1a.id
  subnet_id     = aws_subnet.primepath_project_public_subnet-az1a.id

  depends_on = [
    aws_internet_gateway.primepath_project_igw,
    aws_subnet.primepath_project_public_subnet-az1a,
  ]

  tags = {
    Name = "primepath_project_nat_gateway-az1a"
  }
}

# Public Route Table
resource "aws_route_table" "primepath_public_rt" {
  vpc_id = aws_vpc.primepath_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primepath_project_igw.id
  }

  tags = {
    Name = "Route Table for Public Subnets"
  }
}

resource "aws_route_table_association" "public_subnet_association_az1a" {
  subnet_id      = aws_subnet.primepath_project_public_subnet-az1a.id
  route_table_id = aws_route_table.primepath_public_rt.id
}

resource "aws_route_table_association" "public_subnet_association_az1b" {
  subnet_id      = aws_subnet.primepath_project_public_subnet-az1b.id
  route_table_id = aws_route_table.primepath_public_rt.id
}

# Private Route Table (app + DB)
resource "aws_route_table" "primepath_private_rt" {
  vpc_id = aws_vpc.primepath_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.primepath_nat_gateway-az1a.id
  }

  tags = {
    Name = "Route Table for Private Subnets"
  }
}

resource "aws_route_table_association" "private_app_subnet_association_az1a" {
  subnet_id      = aws_subnet.primepath_project_private_app_subnet-az1a.id
  route_table_id = aws_route_table.primepath_private_rt.id
}

resource "aws_route_table_association" "private_db_subnet_association_az1a" {
  subnet_id      = aws_subnet.primepath_project_private_db_subnet-az1a.id
  route_table_id = aws_route_table.primepath_private_rt.id
}

resource "aws_route_table_association" "private_app_subnet_association_az1b" {
  subnet_id      = aws_subnet.primepath_project_private_app_subnet-az1b.id
  route_table_id = aws_route_table.primepath_private_rt.id
}

resource "aws_route_table_association" "private_db_subnet_association_az1b" {
  subnet_id      = aws_subnet.primepath_project_private_db_subnet-az1b.id
  route_table_id = aws_route_table.primepath_private_rt.id
}



/*

NOTE: For your capstone project, you will segregate route tables based on the private app subnets and private database subnets.
You will create a route table for the private app subnets and a separate route table for the private database subnets. This will allow you to manage routing rules independently for each type of subnet, providing better control over network traffic and security.

*/
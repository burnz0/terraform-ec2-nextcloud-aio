#### 1 Setting up VPC

# Create a VPC
resource "aws_vpc" "nextcloud_aio_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "nextcloud-aio-vpc"
  }
}

# Create subnets (public and private as needed)
resource "aws_subnet" "public_subnet_1" {
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.nextcloud_aio_vpc.id
}

# Create an Internet Gateway (IGW)
resource "aws_internet_gateway" "nextcloud_aio_igw" {
  vpc_id = aws_vpc.nextcloud_aio_vpc.id
  tags = {
    Name = "nextcloud-aio-igw"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.nextcloud_aio_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nextcloud_aio_igw.id
  }
}

resource "aws_route_table_association" "subnet_route" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

# Create a security group in the correct VPC
resource "aws_security_group" "nextcloud-sg" {
  name        = "nextcloud-aio-sg"
  description = var.security_group_description
  vpc_id      = aws_vpc.nextcloud_aio_vpc.id

  # Define your security group rules here
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  # Allow inbound traffic on port 8080 (HTTP)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world for port 8080 (customize as needed)
  }

  # Allow inbound traffic on port 443 (HTTPS)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world for port 443 (customize as needed)
  }

  # Allow inbound traffic on port 8443 (HTTPS)
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world for port 8443 (customize as needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
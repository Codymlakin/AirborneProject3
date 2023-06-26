resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Eagles-vpc"
  }
}

resource "aws_subnet" "subnet_private" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.main.id
  #cidrsubnet elemenet references main vpc, adds 8 to cidr block, counts up by 1
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "Eagles${count.index + 1}-Private"
  }
}

resource "aws_subnet" "subnet_public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 3)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Eagles${count.index + 1}-public"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# IGW is needed for public access
# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "EaglesIGW"
  }
}

# Public and Private Route Tables
# Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "EaglesPublicRouteTable"
  }
}

# Create a private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "EaglesPrivateRouteTable"
  }

  route {
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public[0].id

  tags = {
    Name = "EaglesNATGateway"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "EaglesNATGatewayEIP"
  }
}

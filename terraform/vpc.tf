# VPC create 
resource "aws_vpc" "loljoa2-vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "loljoa2-vpc"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

# Elastic IP - Natgateway
resource "aws_eip" "loljoa2-nat-eip" {
  vpc = true
  tags = {
    "Name" = "loljoa2-nat-eip"
  }
}

# Natgateway - public-subnet, EIP connect
resource "aws_nat_gateway" "loljoa2-nat" {
  allocation_id = aws_eip.loljoa2-nat-eip.id
  subnet_id = aws_subnet.loljoa2-pub-sub.id

  tags = {
    "Name" = "loljoa2-nat"
  }
}

# public subnet create
resource "aws_subnet" "loljoa2-pub-sub" {
  availability_zone       = "ap-northeast-2a"
  cidr_block              = "192.168.10.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.loljoa2-vpc.id

  tags = {
    "Name" = "loljoa2-pub-sub"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

# private subnet create
  resource "aws_subnet" "loljoa2-pri-sub-a" {
  availability_zone       = "ap-northeast-2a"
  cidr_block              = "192.168.20.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.loljoa2-vpc.id

  tags = {
    "Name" = "loljoa2-pri-sub-a"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "loljoa2-pri-sub-c" {
  availability_zone       = "ap-northeast-2c"
  cidr_block              = "192.168.30.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.loljoa2-vpc.id

  tags = {
    "Name" = "loljoa2-pri-sub-c"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_internet_gateway" "loljoa2-igw" {
  vpc_id = aws_vpc.loljoa2-vpc.id

  tags = {
    Name = "loljoa2-igw"
  }
}



# public route table
resource "aws_route_table" "loljoa2-pub-route" {
  vpc_id = aws_vpc.loljoa2-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.loljoa2-igw.id
  }

  tags = {
    "Name" = "loljoa2-pub-route"
  }
}

# private route table
resource "aws_route_table" "loljoa2-pri-route" {
  vpc_id = aws_vpc.loljoa2-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.loljoa2-nat.id
  }

  tags = {
    "Name" = "loljoa2-pri-route"
  }
}

# public route table association
resource "aws_route_table_association" "loljoa2-pub-routing" {

  subnet_id      = aws_subnet.loljoa2-pub-sub.id
  route_table_id = aws_route_table.loljoa2-pub-route.id
}

# private route table association
resource "aws_route_table_association" "loljoa2-pri-routing1" {
  
  subnet_id      = aws_subnet.loljoa2-pri-sub-a.id
  route_table_id = aws_route_table.loljoa2-pri-route.id
}

resource "aws_route_table_association" "loljoa2-pri-routing2" {

  subnet_id      = aws_subnet.loljoa2-pri-sub-c.id
  route_table_id = aws_route_table.loljoa2-pri-route.id
}

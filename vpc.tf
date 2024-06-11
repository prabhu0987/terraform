resource "aws_vpc" "ibm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ibm"
  }
}

#public subnet

resource "aws_subnet" "ibm-web-sn" {
  vpc_id     = aws_vpc.ibm-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ibm-web-subnet"
  }
}

#private subnet

resource "aws_subnet" "ibm-db-sn" {
  vpc_id     = aws_vpc.ibm-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "ibm-database-subnet"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "ibm-igw" {
  vpc_id = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-internet-igw"
  }
}

#public route table 

resource "aws_route_table" "ibm-web-rt" {
  vpc_id = aws_vpc.ibm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm-igw.id
  }
   tags = {
    Name = "ibm-web-route-table"
  }
}

#Public route table association

resource "aws_route_table_association" "ibm-web-rt-association" {
  subnet_id      = aws_subnet.ibm-web-sn.id
  route_table_id = aws_route_table.ibm-web-rt.id
}

#private route table 

resource "aws_route_table" "ibm-db-rt" {
  vpc_id = aws_vpc.ibm-vpc.id

 
   tags = {
    Name = "ibm-database-route-table"
  }
}

#Pprivate route table association

resource "aws_route_table_association" "ibm-db-rt-association" {
  subnet_id      = aws_subnet.ibm-db-sn.id
  route_table_id = aws_route_table.ibm-db-rt.id
}
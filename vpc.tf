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

# public nacl

resource "aws_network_acl" "ibm-web-nacl" {
  vpc_id = aws_vpc.ibm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ibm-web-nacl"
  }
}

# public nacl association

resource "aws_network_acl_association" "ibm-web-nacl-association" {
  network_acl_id = aws_network_acl.ibm-web-nacl.id
  subnet_id      = aws_subnet.ibm-web-sn.id
}

# private nacl

resource "aws_network_acl" "ibm-db-nacl" {
  vpc_id = aws_vpc.ibm-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "ibm-database-nacl"
  }
}

# private nacl association

resource "aws_network_acl_association" "ibm-db-nacl-association" {
  network_acl_id = aws_network_acl.ibm-db-nacl.id
  subnet_id      = aws_subnet.ibm-db-sn.id
}

# public security group 

resource "aws_security_group" "ibm-web-sg" {
  name        = "ibm-web-server-sg"
  description = "Allow web server traffic"
  vpc_id      = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-web-security-group"
  }
}

# ssh Traffic

resource "aws_vpc_security_group_ingress_rule" "ibm-web-ssh" {
  security_group_id = aws_security_group.ibm-web-sg.id
  cidr_ipv4         = 0.0.0.0/0
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# HTTP Traffic

resource "aws_vpc_security_group_ingress_rule" "ibm-web-http" {
  security_group_id = aws_security_group.ibm-web-sg.id
  cidr_ipv4         = 0.0.0.0/0
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
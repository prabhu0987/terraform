resource "aws_vpc" "ecomm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecomm"
  }
}

#public subnet

resource "aws_subnet" "ecomm-web-sn" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ecomm-web-subnet"
  }
}

#private subnet

resource "aws_subnet" "ecomm-db-sn" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "ecomm-database-subnet"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "ecomm-igw" {
  vpc_id = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-internet-igw"
  }
}

#public route table 

resource "aws_route_table" "ecomm-web-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm-igw.id
  }
   tags = {
    Name = "ecomm-web-route-table"
  }
}

#Public route table association

resource "aws_route_table_association" "ecomm-web-rt-association" {
  subnet_id      = aws_subnet.ecomm-web-sn.id
  route_table_id = aws_route_table.ecomm-web-rt.id
}

#private route table 

resource "aws_route_table" "ecomm-db-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

 
   tags = {
    Name = "ecomm-database-route-table"
  }
}

#Pprivate route table association

resource "aws_route_table_association" "ecomm-db-rt-association" {
  subnet_id      = aws_subnet.ecomm-db-sn.id
  route_table_id = aws_route_table.ecomm-db-rt.id
}

# public nacl

resource "aws_network_acl" "ecomm-web-nacl" {
  vpc_id = aws_vpc.ecomm-vpc.id

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
    Name = "ecomm-web-nacl"
  }
}

# public nacl association

resource "aws_network_acl_association" "ecomm-web-nacl-association" {
  network_acl_id = aws_network_acl.ecomm-web-nacl.id
  subnet_id      = aws_subnet.ecomm-web-sn.id
}

# private nacl

resource "aws_network_acl" "ecomm-db-nacl" {
  vpc_id = aws_vpc.ecomm-vpc.id

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
    Name = "ecomm-database-nacl"
  }
}

# private nacl association

resource "aws_network_acl_association" "ecomm-db-nacl-association" {
  network_acl_id = aws_network_acl.ecomm-db-nacl.id
  subnet_id      = aws_subnet.ecomm-db-sn.id
}

# public security group 

resource "aws_security_group" "ecomm-web-sg" {
  name        = "ecomm-web-server-sg"
  description = "Allow web server traffic"
  vpc_id      = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-web-security-group"
  }
}

# ssh Traffic

resource "aws_vpc_security_group_ingress_rule" "ecomm-web-ssh" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# HTTP Traffic

resource "aws_vpc_security_group_ingress_rule" "ecomm-web-http" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#outbound Traffic allow

resource "aws_vpc_security_group_egress_rule" "ecomm-outbound" {
  security_group_id = aws_security_group.ecomm-web-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65635
}
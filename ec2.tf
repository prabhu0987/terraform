resource "aws_instance" "ibm-web-server" {
  ami           = ami-011e54f70c1c91e17 
  instance_type = "t3.micro"
  subnet_id = aws_subnet.ibm-web-sn.id
  key_name = "stock-key"
  vpc_security_group_ids = aws_security_group.ibm-web-sg.id
 
  tags = {
    Name = "ibm-web-server"
  }
}

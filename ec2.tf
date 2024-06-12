resource "aws_instance" "ecomm-web-server" {
  ami           = ami-011e54f70c1c91e17 
  instance_type = "t3.micro"
  subnet_id = aws_subnet.ecomm-web-sn.id
  key_name = "stock-key"
  vpc_security_group_ids = [aws_security_group.ecomm-web-sg.id]
  user_data = file("ecomm.sh")
  tags = {
    Name = "ecomm-web-server"
  }
}

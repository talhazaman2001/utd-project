
# EC2 Instance in Public Subnet
resource "aws_instance" "backend_instance" {
  ami           = "ami-0b31d93fb777b6ae6" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.backend_sg.id]

  tags = {
    Name = "backend-instance"
  }
}



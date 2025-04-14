resource "aws_instance" "app_server" {
  ami             = "ami-084568db4383264d4"  
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_a.id
  key_name        = "my-key-pair"  
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "App Server"
  }
}

resource "aws_instance" "jenkins_server" {
  ami             = "ami-084568db4383264d4"  
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_b.id
  key_name        = "my-key-pair"  
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "Jenkins Server"
  }
}
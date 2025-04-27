resource "aws_instance" "jenkins_server" {
  ami                    = "ami-0f9de6e2d2f067fca"  # Ubuntu-based AMI
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.subnet_b.id
  key_name               = "my-key-pair"
  vpc_security_group_ids = [aws_security_group.sg.id]
  
  # SSH access
  user_data = <<-EOF
              #!/bin/bash
              # Install necessary tools
              apt-get update
              apt-get install -y python3-pip
              apt-get install -y ansible
              EOF

  tags = {
    Name = "Jenkins Server"
  }



  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/Abdelrahman/.ssh/my-key-pair.pem")
    host        = self.public_ip
  }
}

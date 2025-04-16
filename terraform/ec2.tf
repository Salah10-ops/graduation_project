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

  # Automatically run Docker and Jenkins setup after EC2 instance is created
  provisioner "remote-exec" {
#    inline = [
#      "sudo apt update -y",
#      "sudo apt install -y python3-pip docker.io",
#      "sudo usermod -aG docker ubuntu",  # Add user to Docker group
#      "sudo docker run -d -p 8080:8080 --name jenkins jenkins/jenkins:lts"
#    ]
    inline = [
      "sudo apt update -y",
      "sudo apt install -y openjdk-11-jdk",
      "wget -q -O - https://pkg.jenkins.io/keys/jenkins.io.key | sudo tee -a /etc/apt/trusted.gpg.d/jenkins.asc",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian/ stable main > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt update -y",
      "sudo apt install jenkins -y",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/Abdelrahman/.ssh/my-key-pair.pem")  # Adjust path to your private key
      host        = self.public_ip
    }
  }
}
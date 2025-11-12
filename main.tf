provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "mysql_server" {
  ami                    = "ami-03695d52f0d883f65"  # Amazon Linux 2 AMI for ap-south-1
  instance_type          = "t3.micro"
  key_name               = "vvvv"
  vpc_security_group_ids = ["sg-057023d978f55cc4e"]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    docker pull mysql:latest
    docker run -d \
      --name mydb \
      -e MYSQL_ROOT_PASSWORD=root123 \
      -e MYSQL_DATABASE=testdb \
      -p 3306:3306 \
      mysql:latest

    # Confirmation message
    echo "✅ Docker and MySQL setup completed" > /home/ec2-user/setup-status.log
  EOF

  tags = {
    Name = "Terraform-MySQL-Instance"
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Allow SSH and MySQL"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "allow_http" {
  name = "allow_http"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "frontend" {
  ami           = "ami-0363648a81209a098"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.allow_http.id]
  tags = {
    Name = "frontend"
  }

  provisioner "file" {
    source      = "configuration.sh"
    destination = "/home/ubuntu/configuration.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/configuration.sh",
      "/home/ubuntu/configuration.sh"
    ]
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0363648a81209a098"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  security_groups = [aws_security_group.allow_http.id]
  tags = {
    Name = "backend"
  }

  provisioner "file" {
    source      = "configuration.sh"
    destination = "/home/ubuntu/configuration.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/configuration.sh",
      "/home/ubuntu/configuration.sh"
    ]
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "flask_sg" {
  name        = "flask_security_group"
  description = "Allow inbound traffic for Flask, Prometheus, and Grafana"

  ingress {
    from_port   = 22               # 🔑 SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    # Or better: your IP only
  }

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Flask
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Prometheus
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Grafana
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "flask_server" {
  ami           = "ami-0e35ddab05955cf57" 
  instance_type = "t2.micro"
  key_name      = "terraform-key"       # 🔁 Replace with your actual key pair name

  security_groups = [aws_security_group.flask_sg.name]

  tags = {
    Name = "FlaskAppServer"
  }
}

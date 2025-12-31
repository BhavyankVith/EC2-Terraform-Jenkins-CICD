provider "aws" {
  region = "ap-northeast-1"
}

# This block looks up the latest Amazon Linux 2 AMI in Tokyo automatically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = file("~/.ssh/devops-key.pub")
}
resource "aws_security_group" "web_sg" {
  name        = "allow_web_ssh"
  description = "Allow HTTP and SSH"

  # 1. SSH Access (Missing this was causing the timeout)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # 2. HTTP Access (For the browser)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 3. Outbound Rules (Allow instance to talk to the internet)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "app" {
  # We reference the data source here instead of a hardcoded string
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.devops_key.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "devops-demo"
  }
}

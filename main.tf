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
resource "aws_instance" "app" {
  # We reference the data source here instead of a hardcoded string
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.devops_key.key_name

  tags = {
    Name = "devops-demo"
  }
}

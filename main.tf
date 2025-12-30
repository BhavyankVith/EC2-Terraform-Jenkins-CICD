provider "aws" {
  region = "ap-north-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0abcdef12345"
  instance_type = "t2.micro"

  tags = {
    Name = "devops-demo"
  }
}

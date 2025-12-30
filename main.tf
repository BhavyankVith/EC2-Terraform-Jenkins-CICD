provider "aws" {
  region = "ap-north-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"

  tags = {
    Name = "devops-demo"
  }
}

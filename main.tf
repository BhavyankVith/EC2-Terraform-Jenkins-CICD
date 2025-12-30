provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0b46816ffa1234887"
  instance_type = "t3.micro"

  tags = {
    Name = "devops-demo"
  }
}

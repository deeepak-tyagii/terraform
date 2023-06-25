terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "intro" {
  ami                    = "ami-022e1a32d3f742bd8"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  key_name               = "bean-key"
  vpc_security_group_ids = ["sg-0868e2723d9e473b2"]
  tags = {
    Name    = "terra-instance"
    Project = "Terraform"
  }
}
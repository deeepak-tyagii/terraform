terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-file-dt"
    key    = "test/aws_infra"
    region = "us-east-1"
  }
}
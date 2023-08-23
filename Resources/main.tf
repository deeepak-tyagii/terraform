# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

locals {
  server_name = "s3-${var.environment}-bucket"
}

# Create the AWS S3 Bucket
resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "My s3 Bucket"
    server_name = local.server_name
    Region = data.aws_region.current.name
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "my_new_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_ownership]
  bucket     = aws_s3_bucket.my-s3-bucket.id
  acl        = "private"
}

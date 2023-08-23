module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket-deepaktyagi-module"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

module "server" {
source = "./server"
ami = data.aws_ami.ubuntu.id
subnet_id = aws_subnet.public_subnets["public_subnet_3"].id
security_groups = [
aws_security_group.vpc-ping.id,
aws_security_group.ingress-ssh.id,
aws_security_group.vpc-web.id
]
}
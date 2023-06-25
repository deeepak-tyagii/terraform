resource "aws_instance" "intro" {
  ami                    = var.AMI[var.REGION]
  instance_type          = var.InstanceType
  availability_zone      = var.ZONE1
  key_name               =var.KeyName
  vpc_security_group_ids = var.SECGROUP
  tags = {
    Name    = "terra-instance"
    Project = "Terraform"
  }
}
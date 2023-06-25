variable "REGION" {
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "SECGROUP" {
  default = ["sg-0868e2723d9e473b2"]
}

variable "InstanceType" {
  default = "t2.micro"
}

variable "AMI" {
  type = map(any)
  default = {
    us-east-1 = "ami-022e1a32d3f742bd8"
    us-east-2 = "ami-0e820afa569e84cc1"
  }
}

variable "USER" {
  default = "ec2-user"
}

variable "MyIP" {
	default = ["139.5.242.230/32"]
}

variable "VPC-ID" {
	default = "vpc-06aae491d20cb3c45"
}

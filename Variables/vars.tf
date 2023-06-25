variable "REGION" {
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "SECGROUP" {
  default = ["sg-0868e2723d9e473b2"]
}

variable "AMI" {
  type = map(any)
  default = {
    us-east-1 = "ami-022e1a32d3f742bd8"
    us-east-2 = "ami-0e820afa569e84cc1"
  }
}

variable "KeyName" {
  default = "bean-key"
}

variable "InstanceType" {
  default = "t2.micro"
}
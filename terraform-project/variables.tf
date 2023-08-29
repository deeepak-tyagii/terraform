variable "environment" {
  type    = string
  default = "project"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}($|/(16|24))$", var.vpc_cidr))
    error_message = "Please provide the CIDR Block in form of X.X.X.X/X"
  }
}

variable "public_subnets" {
  type = map(any)
  default = {
    public_subnet_1 = 1
    public_subnet_2 = 2
    public_subnet_3 = 3
  }
}

variable "private_subnets" {
  type = map(any)
  default = {
    private_subnet_1 = 1
    private_subnet_2 = 2
    private_subnet_3 = 3
  }
}

variable "instanceType" {
  default = "t2.small"
}

variable "ami" {
  type = map(any)
  default = {
    us-east-1 = "ami-053b0d53c279acc90"
    us-east-2 = "ami-0e820afa569e84cc1"
  }
}

variable "user" {
  default = "ubuntu"
}

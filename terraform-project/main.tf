# Configure the AWS Provider
provider "aws" {
  region = var.region
}

#Retrieve my dynamic IP Address for Security Group
data "http" "my_ip" {
  url = "http://ipinfo.io/ip"
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name        = "my-demo-vpc"
    Environment = var.environment
    terraform   = "true"
  }
}

#Deploy the private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name        = each.key
    Environment = var.environment
    terraform   = "true"
  }
}

#Deploy the public subnets
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name        = each.key
    Environment = var.environment
    terraform   = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "demo-igw"
    Environment = var.environment
    terraform   = "true"
  }
}

#Create EIP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "demo_igw_eip"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_subnet.public_subnets]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  tags = {
    Name = "demo_nat_gateway"
  }
}

#Create route tables for public and private subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "demo_public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "demo_private_rtb"
    Terraform = "true"
  }
}

#Create route tables association with public and private subnets
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_rt.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_rt.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

#Create security group allowing traffic from port 22 and 80
resource "aws_security_group" "demo-sec-group" {
  name        = "demo-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Allow http and ssh inbound traffic"

  ingress {
    description = "allow port 80 from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${data.http.my_ip.body}/32"]
  }

  ingress {
    description = "allow port 22 from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.my_ip.body}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#Create the private key
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

#Copy private key to local
resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyAWSKey.pem"
}

#Create the aws key pair using the private local key
resource "aws_key_pair" "generated" {
  key_name   = "MyAWS_TF_Key"
  public_key = tls_private_key.generated.public_key_openssh
}

#Create the AWS EC2 Instance and provision our website
resource "aws_instance" "demo-instance" {
  ami                         = var.ami[var.region]
  instance_type               = var.instanceType
  subnet_id                   = aws_subnet.public_subnets["public_subnet_1"].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated.key_name
  vpc_security_group_ids      = [aws_security_group.demo-sec-group.id]
  tags = {
    Name    = "terra-instance"
    Project = "Terraform"
  }

  connection {
    user        = var.user
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /tmp",
      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }
}

output "PublicIP" {
  value = aws_instance.demo-instance.public_ip
}

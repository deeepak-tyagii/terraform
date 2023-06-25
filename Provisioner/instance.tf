resource "aws_security_group" "dove-sec-group" {
  name        = "dove-sg"
  description = "Allow Dove inbound traffic"
  vpc_id      = var.VPC-ID

  ingress {
    description      = "Dove port 80 from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.MyIP
  }

  ingress {
    description = "Dove port 22 from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.MyIP
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

resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file("dovekey.pub")
}

resource "aws_instance" "dove-instance" {
  ami               = var.AMI[var.REGION]
  instance_type     = var.InstanceType
  availability_zone = var.ZONE1
  key_name          = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.dove-sec-group.id]
  tags = {
    Name    = "terra-instance"
    Project = "Terraform"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("dovekey")
    host        = self.public_ip
  }
}

output "PublicIP" {
  value = aws_instance.dove-instance.public_ip
}
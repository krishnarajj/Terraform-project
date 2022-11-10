terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.REGION
}
resource "aws_vpc" "kvvpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    vpc = "kvvpc"
  }
}
resource "aws_subnet" "kvpub1" {
  vpc_id                  = aws_vpc.kvvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONES[var.REGION]
  tags = {
    subnet = "kvpublic1"
  }
}
resource "aws_subnet" "kvpub2" {
  vpc_id                  = aws_vpc.kvvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONES[var.REGION]
  tags = {
    subnet = "kvpublic2"
  }
}
resource "aws_subnet" "kvpri1" {
  vpc_id                  = aws_vpc.kvvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONES[var.REGION]
  tags = {
    subnet = "kvprivate1"
  }
}
resource "aws_subnet" "kvpri2" {
  vpc_id                  = aws_vpc.kvvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONES[var.REGION]
  tags = {
    subnet = "kvprivate2"
  }
}
resource "aws_internet_gateway" "kvgateway" {
  vpc_id = aws_vpc.kvvpc.id
}
resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.kvvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kvgateway.id
  }
}
resource "aws_route_table_association" "kvpubroute1" {
  subnet_id      = aws_subnet.kvpub1.id
  route_table_id = aws_route_table.publicroute.id
}
resource "aws_route_table_association" "kvpubroute2" {
  subnet_id      = aws_subnet.kvpub2.id
  route_table_id = aws_route_table.publicroute.id
}
resource "aws_security_group" "kvsecuritygroup" {
  name        = "kvsecuritygroup"
  description = "kvsecuritygroup"
  vpc_id      = aws_vpc.kvvpc.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "kvsec"
  }
}
resource "aws_key_pair" "kv-key" {
  key_name   = "kv-key"
  public_key = file("./key/kv-key.pub")
}
resource "aws_instance" "kvinstance" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONES[var.REGION]
  subnet_id              = aws_subnet.kvpub1.id
  key_name               = aws_key_pair.kv-key.key_name
  vpc_security_group_ids = [aws_security_group.kvsecuritygroup.id]
  tags = {
    "name" = "terrainstance"
  }
  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }
  connection {
    user        = var.USER
    private_key = file("./key/kv-key")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]

  }

}
resource "aws_ebs_volume" "kvvolume" {
  availability_zone = var.ZONES[var.REGION]
  size              = 3

  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.kvvolume.id
  instance_id = aws_instance.kvinstance.id
}
output "Public-ip" {
  value = aws_instance.kvinstance.public_ip
}
output "Private_ip" {
  value = aws_instance.kvinstance.private_ip
}

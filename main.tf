terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.3.7"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_subnet" "public_subnet_a" {
    vpc_id = var.vpc_security_group_id
    cidr_block = "10.10.0.0/24"
    availability_zone = "us-east-1a"
  
}

resource "aws_subnet" "public_subnet_b" {
    vpc_id = var.vpc_security_group_id
    cidr_block = "10.10.1.0/24"
    availability_zone = "us-east-1b"
  
}

resource "aws_subnet" "private_subnet_a" {
    vpc_id = var.vpc_security_group_id
    cidr_block = "10.10.3.0/24"
    availability_zone = "us-east-1a"
  
}

resource "aws_subnet" "private_subnet_b" {
    vpc_id = var.vpc_security_group_id
    cidr_block = "10.10.4.0/24"
    availability_zone = "us-east-1b"
  
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rdssubnet"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  tags = {
    Name = "my_db_subnet_group"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = var.name_security_group
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_security_group_id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_SSH"
  }
}

resource "aws_instance" "webserver" {
    ami = var.ami_aws_instance
    instance_type = var.instance_type
    subnet_id = aws_subnet.private_subnet_a.id
  
}

resource "aws_db_instance" "rds_instance" {
allocated_storage = 10
vpc_security_group_ids = [aws_security_group.allow_ssh.id]
identifier = "lab-rds-jv"
storage_type = "gp2"
engine = "mysql"
engine_version = "8.0.27"
instance_class = "db.t2.micro"
db_name = "rdsclass"
username = "RDSuser"
password = "Elfos123"
publicly_accessible    = true
skip_final_snapshot    = true
db_subnet_group_name = aws_db_subnet_group.rds_subnet.id

tags = {
  Name = "RDS-server"
  }
}
variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "default"
}

variable "name_security_group" {
  default = "allow_ssh"
  
} 

variable "vpc_security_group_id" {
  default = ""
}

variable "ami_aws_instance" {
  default = "ami-0778521d914d23bc1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {
  default = ""
  
}

variable "key_name" {
  default = "" 
}

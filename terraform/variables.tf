provider "aws" {
  region = "us-east-1"
  profile = "personal"
}

variable "ami" {
  default = "ami-0c6b1d09930fac512"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_security_group_ids" {
  default = "sg-0ba83343db2fd487d"
}

variable "key_name" {
  default = "default-personal-kp"
}

locals {
  tags = "${map("terraform", "true", "test", "true")}" 
}

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

variable "hostname" {
  default = "ansible-test.example.bushbs.com"
}

variable "server-type" {
  default = "webserver"
}

locals {
  tags = "${map("terraform", "true", 
                "test", "true",
                "server-type", "${var.server-type}",
                "checkout-name", var.checkout-name)
           }" 
}

variable "checkout-name" {
  description = "Supplied by CI server, should be either the branch or tag to build this server from"
}

terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-bbush"
    key            = "terraform.tfstate.test-state"
    dynamodb_table = "bbush-terraform-lock"
    region         = "us-east-1"
    encrypt        = true
  }
}

data "template_file" "user_data_template" {
    template = "${file("${path.module}/user_data.sh.template")}"
    
    # vars {

    # }
}

resource "aws_instance" "test-server" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  key_name                    = "${var.key_name}"
  tags                        = "${local.tags}"
  volume_tags                 = "${local.tags}"
  user_data                   = "${data.template_file.user_data_template.rendered}"
  root_block_device {
    delete_on_termination = true
  }
}
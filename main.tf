provider "aws"{

  region = var.region

}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-nxgcloud-infra-development"
    key            = "global/infra/sg.tfstate"
    region         = "ap-south-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = "terraform-nxgcloud-infra-development"
    key            = "global/infra/vpc.tfstate"
    region         = "ap-south-1"
  }
}

resource "aws_security_group" "bastion" {
  name   = "Bastion"
  vpc_id = "${data.terraform_remote_state.vpc.outputs.vpc_id}"

}

resource "aws_security_group" "common" {
  name   = "Common"
  vpc_id = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
}

resource "aws_security_group_rule" "allow_icmp_ingress" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = var.desktop_cidr
  security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "allow_icmp_egress" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion.id}"
}

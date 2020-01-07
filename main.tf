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


resource "aws_security_group" "ec2_basic_sg" {
  name   = "ec2_basic_sg"
  vpc_id = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
}

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

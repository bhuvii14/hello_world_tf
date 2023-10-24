
terraform {
  backend "s3" {
    bucket = "demo-app-terraform-state-file"
    key    = "demo/vpc/vpc.tfstate"
    region = "ap-south-1"


  }
}



module "dev_vpc" {

  source         = "../../modules/vpc"
  cidr_block     = var.cidr_block
  pri_sub_1_cidr = var.pri_sub_1_cidr
  pri_sub_2_cidr = var.pri_sub_2_cidr
  pub_sub_1_cidr = var.pub_sub_1_cidr
  pub_sub_2_cidr = var.pub_sub_2_cidr
  ProjectName    = var.ProjectName
  environment    = var.environment
  region         = var.region

}



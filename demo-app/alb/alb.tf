
terraform {
  backend "s3" {
    bucket = "demo-app-terraform-state-file"
    key    = "demo/alb/alb.tfstate"
    region = "ap-south-1"


  }
}


module "alb" {
  source             = "../../modules/alb/"
  ProjectName        = var.ProjectName
  environment        = var.environment
  security_groups_id = ["${module.alb_sg.security_group_id.id}"]
  pub_subnet_id      = var.pub_subnet_id
  vpc_id             = var.vpc_id

  depends_on = [
    module.alb_sg
  ]

}


module "alb_sg" {
  source        = "../../modules/sg/"
  ProjectName   = var.ProjectName
  environment   = var.environment
  vpc_id        = var.vpc_id
  ingress_ports = [80, 443]
  cidr_blocks   = ["0.0.0.0/0"]
  resource_name = "alb"

}

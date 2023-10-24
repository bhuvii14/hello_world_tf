
terraform {
  backend "s3" {
    bucket = "demo-app-terraform-state-file"
    key    = "demo/ecs/helloworld.tfstate"
    region = "ap-south-1"


  }
}


module "ecs" {
  source                    = "../../../modules/ecs/"
  cpu                       = var.cpu
  memory                    = var.memory
  container_port            = var.container_port
  host_port                 = var.host_port
  container_image           = var.container_image
  cluster_name              = var.cluster_name
  ecs_subnet_ids            = var.ecs_subnet_ids
  vpc_id                    = var.vpc_id
  target_group_health_check = var.target_group_health_check
  alb_security_group_id     = var.alb_security_group_id
  alb_listener_arn          = var.alb_listener_arn
  alb_path_based_listener   = var.alb_path_based_listener
  ProjectName               = var.ProjectName
  servicename               = var.servicename
  environment               = var.environment
  region                    = var.region


}

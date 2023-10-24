

terraform {
  backend "s3" {
    bucket = "demo-app-terraform-state-file"
    key    = "demo/ecs/ecs.tfstate"
    region = "ap-south-1"


  }
}


resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.ProjectName}-ecs-cluster-${var.environment}"
    setting {
    name  = "containerInsights"
    value = "enabled"
  }

     tags = {
    environment = var.environment
    
  }

}

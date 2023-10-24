# ECS task definition

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${ var.ProjectName }-${var.servicename}-${ var.environment}"
  container_definitions = data.template_file.task_definition.rendered
  task_role_arn            = module.task-role.iam_role_arn
  execution_role_arn       = module.execution-role.iam_role_arn
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name        = "${ var.ProjectName }-${var.servicename}-ecs-task--${ var.environment}"
    ProjectName = var.ProjectName
    environment=var.environment

  }
}

data "template_file" "task_definition" {
  template = file("./task-definition.json")
  #  container_name = var.container_name
    # image_name = var.container_image
    # ProjectName = var.ProjectName
    # environment=var.environment
      # container_port=var.container_port
  # host_port=var.host_port

    vars = {
   container_name = "${ var.ProjectName }-${var.servicename}-${ var.environment}"
    image_name = var.container_image
    ProjectName = var.ProjectName
    environment=var.environment
      container_port=var.container_port
  host_port=var.host_port
  region=var.region
  servicename=var.servicename

  } 
}

module "task-role" {
  source = "../iam/role/"
  ProjectName=var.ProjectName
  environment = var.environment
  servicename=var.servicename
  role_name = "task-role"
  additional_permissions = var.additional_permissions
  resource_arn=var.resource_arn
}


module "execution-role" {
  source = "../iam/role/"
  ProjectName=var.ProjectName
  environment = var.environment
  role_name = "execution-role"
  additional_permissions = var.additional_permissions
  resource_arn=var.resource_arn
  servicename=var.servicename
}
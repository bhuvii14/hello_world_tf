# ECR Variables

variable "ProjectName" {
  type = string
}
variable "servicename" {
  type = string

}
variable "environment" {
  type = string

}

variable "cpu" {
  type = number
}
variable "memory" {
  type = number
}

variable "container_port" {
  description = "Port of the ecs container"
  type        = number
}

variable "container_image" {
  description = "Image name for docker task"
  type        = string
}

variable "host_port" {
  type = number
}


##ECS Service Variables

variable "cluster_name" {
  type = string
}

variable "ecs_subnet_ids" {
  description = "Subnet IDs for the ECS service"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "target_group_health_check" {
  description = "Health check path for target group"
  type        = string
}


variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALB listener arn"
  type        = string
}

variable "alb_path_based_listener" {
  description = "Add this variables for the path based listener in alb"
  type        = string
  default     = ""
}
variable "region" {
  type = string
}

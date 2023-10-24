variable "network_mode" {
    type = string
    default = "awsvpc"  
}
variable "cpu" {
  type = number
}
variable "memory" {
  type = number
}
/*variable "container_name" {
  description = "Name for the ECS container"
  type = string
}
*/
variable "container_port" {
  description = "Port of the ecs container"
  type = number
}

variable "container_image" {
  description = "Image name for docker task"
  type = string
}

variable "host_port" {
  type = number
}

variable "additional_permissions" {
  description = "Additional permissions for IAM role"
  type = list(any)
  default = []
}

variable "resource_arn" {
  description = "Resource ARN"
  type = list(any)
  default = ["*"]
}

##ECS Service Variables

variable "cluster_name" {
  type=string
}

variable "ecs_subnet_ids" {
  description = "Subnet IDs for the ECS service"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "target_group_health_check" {
  description = "Health check path for target group"
  type = string
}


variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type = string
}

variable "alb_listener_arn" {
  description = "ALB listener arn"
  type = string
}

variable "alb_path_based_listener" {
  description = "Add this variables for the path based listener in alb"
  type = string
  default = ""
}
variable "region" {
type = string
}
  variable "cidr_blocks" {
    type = list
    default = []
  }


#Autoscaling configuration
  variable "desired_count" {
    type = number
    default= 1
  }

  variable "max_capacity" {
       type = number
    default = 1
  }

  variable "min_capacity" {
      type = number
      default = 1
  }

  variable "cpu_target_value" {
    type = number
    default = 75
  }
  variable "memory_target_value" {
        type = number
       default = 75
  }

  variable "cpu_scale_in_cooldown" {
    type = number
    default = 300
  }
    variable "memory_scale_in_cooldown" {
    type = number
    default = 300
  }
  variable "cpu_scale_out_cooldown" {
    type = number
    default = 300
  }
    variable "memory_scale_out_cooldown" {
    type = number
    default = 300
  }
  
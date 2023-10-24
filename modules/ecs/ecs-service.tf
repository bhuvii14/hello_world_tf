# Create a CW log group for ECS task

resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.ProjectName}-${var.servicename}-${var.environment}"

  tags = {
    Name        = "${var.ProjectName}-${var.servicename}-${var.environment}"
    ProjectName = var.ProjectName
    environment=var.environment
    
  }
}

# ECS service

resource "aws_ecs_service" "app" {
  name                              = "${var.ProjectName}-${var.servicename}-${var.environment}"
  cluster                           = data.aws_ecs_cluster.app.arn
  task_definition                   = aws_ecs_task_definition.task_definition.arn
#   desired_count                     = var.desired_count
  health_check_grace_period_seconds = 60
  launch_type                       = "FARGATE"
    
    tags = {
     Name        = "${var.ProjectName}-${var.servicename}-${var.environment}"
    ProjectName = var.ProjectName
    environment=var.environment
  }
   
  enable_execute_command = true

  network_configuration {
    subnets          = var.ecs_subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = "false"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = "${var.ProjectName}-${var.servicename}-${var.environment}"
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_target_group.alb
  ]

    desired_count   = var.desired_count

  # lifecycle {
  #   ignore_changes = [desired_count]
  # }
}

resource "aws_lb_target_group" "alb" {
  name        = "${var.ProjectName}-${var.servicename}-tg-${var.environment}"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path                = var.target_group_health_check
    port                = var.container_port
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 3
    interval            = 5
    matcher             = "200-302" # has to be HTTP 200 or fails
  }
}

data "aws_ecs_cluster" "app" {
  cluster_name = var.cluster_name
}

resource "aws_security_group" "ecs_sg" {
  name   = "${var.ProjectName}-${var.servicename}-ecs-sg-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.ProjectName}-${var.servicename}-ecs-sg-${var.environment}"
     ProjectName = var.ProjectName
    environment=var.environment

  }
}



resource "aws_lb_listener_rule" "alb_listener_rule_path_based" {
  count = length(var.alb_path_based_listener) > 0 ? 1 : 0
  listener_arn = var.alb_listener_arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
  condition {
    path_pattern {
      values = [var.alb_path_based_listener]
    }
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  # role_arn           = module.autoscaling_iam_role.iam_role_arn
  
  depends_on = [
    aws_ecs_service.app
  ]
}



resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  name               = "${var.ProjectName}-${var.servicename}-cpu-scaling-${var.environment}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
      scale_in_cooldown=var.cpu_scale_in_cooldown
    scale_out_cooldown=var.cpu_scale_out_cooldown
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_target_memory" {
  name               = "${var.ProjectName}-${var.servicename}-memory-scaling-${var.environment}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = var.memory_target_value
    scale_in_cooldown=var.memory_scale_in_cooldown
    scale_out_cooldown=var.memory_scale_out_cooldown
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

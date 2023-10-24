ProjectName     = "demo"
environment     = "test"
vpc_id          = "vpc-09331f1ee5df05752"
cpu             = 256
memory          = 512
container_port  = 80
host_port       = 80
container_image = "demo"
cluster_name    = "Demo-ecs-cluster-test"
ecs_subnet_ids  = ["subnet-0e05750faf6424545", "subnet-047a6baf902caf0c1"]
target_group_health_check = "/"
alb_security_group_id     = "sg-0bc1ef024d863bb72"
alb_listener_arn          = "arn:aws:elasticloadbalancing:ap-south-1:394597785857:listener/app/Demo-alb-test/9e9147cc4da1d380/279a3d1b2a6c8559"
alb_path_based_listener   = "/*"
servicename = "hello-world"
region = "ap-south-1"
provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name    = "simple-vpc"
  cidr    = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = "simple-ecs-cluster"
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "simple" {
  family                   = "simple-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"

  container_definitions = jsonencode([{
    name      = "simpletimeservice"
    image     = var.container_image
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
  }])
}

resource "aws_ecs_service" "simple" {
  name            = "simple-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.simple.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.allow_http.id]
    assign_public_ip = false
  }

  desired_count = 1
}

resource "aws_security_group" "allow_http" {
  name   = "allow-http"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "lb" {
  source  = "terraform-aws-modules/alb/aws"
  name    = "simple-lb"
  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id

  security_groups = [aws_security_group.allow_http.id]

  target_groups = [
    {
      name_prefix      = "simple"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip"
      health_check = {
        path = "/"
      }
    }
  ]

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
      target_group_index = 0
    }
  ]
}

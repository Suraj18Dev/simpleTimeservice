variable "aws_region" {
  default = "ap-south-1"
}

variable "container_image" {
  description = "Docker image (18suraj/simpletimeservice:latest)"
  type        = string
}

variable "app_port" {
  default = 8080
}

variable "vpc_id" {
  description = "The VPC ID to deploy resources in"
  type        = string
}
variable "aws_registry_url" {
  description = "AWS container registry Url"
  type        = string
}

variable "aws_lb_chart_version" {
  description = "AWS Load Balancer Controller Chart version"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "lb_controller_role_arn" {
  description = "Role ARN for AWS Load Balancer Controller"
  type        = string
}
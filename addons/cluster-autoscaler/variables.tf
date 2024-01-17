variable "cluster_autoscaler_chart_version" {
  description = "Cluster Autoscaler Chart version"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "eks_cluster_version" {
  description = "Version for eks cluster"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_autoscaler_role_arn" {
  description = "Role ARN for Cluster Autoscaler"
  type        = string
}
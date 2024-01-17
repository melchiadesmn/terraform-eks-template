variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_blocks_public" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "subnet_cidr_blocks_private" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the VPC"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "prefix_name" {
  description = "Prefix for resources"
  type        = string
}

variable "environment" {
  description = "Stack environment"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
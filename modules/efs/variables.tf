variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "eks_security_group_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}

variable "encrypted" {
  description = "EFS encrypted"
  type        = bool
}

variable "creation_token" {
  description = "EFS creation token"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs for RDS"
  type        = list(string)
}

variable "prefix_name" {
  description = "Prefix for resources"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
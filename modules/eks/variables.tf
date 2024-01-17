variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "eks_cluster_version" {
  description = "Version for eks cluster"
  type        = string
}

variable "addon_name" {
  description = "Addon name"
  type        = list(string)
}

variable "eks_cluster_role" {
  description = "IAM role for EKS cluster"
  type        = any
}

variable "subnet_ids" {
  description = "Subnets IDs for EKS cluster"
  type        = list(string)
}

variable "eks_cluster_policy" {
  description = "Policy for EKS cluster"
  type        = any
}

variable "eks_nodegroup_role" {
  description = "IAM role for EKS nodegroups"
  type        = any
}

variable "eks_nodegroup_policy" {
  description = "Policy for EKS nodegroups"
  type        = any
}

variable "eks_cni_policy" {
  description = "Policy for EKS cni"
  type        = any
}

variable "eks_ecr_policy" {
  description = "Policy for EKS ecr"
  type        = any
}

variable "aws_region" {
  description = "AWS Region"
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

variable "capacity_type" {
  description = "Capacity type for node group"
  type        = string
}

variable "force_update_version" {
  description = "Force update version for node group"
  type        = bool
}

variable "system_instance_types" {
  description = "Instance types for system node group"
  type        = list(string)
}

variable "on_demand_instance_types" {
  description = "Instance types for on demand node groups"
  type        = list(string)
}

variable "spot_instance_types" {
  description = "Instance types for spot node groups"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
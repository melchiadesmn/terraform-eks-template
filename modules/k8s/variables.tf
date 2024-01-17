variable "namespaces" {
  description = "Namespaces to create"
  type        = list(string)
}

variable "efs_resources" {
  description = "EFS resources"
  type        = any
}

variable "eks_nodegroup_role" {
  description = "IAM role for EKS nodegroups"
  type        = any
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "eks_roles" {
  description = "Roles access EKS"
  type        = list(string)
}

variable "eks_users" {
  description = "Users access EKS"
  type        = list(string)
}
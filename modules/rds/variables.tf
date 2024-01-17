variable "prefix_name" {
  description = "Prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for RDS"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the VPC"
  type        = list(string)
}

variable "pg_family" {
  description = "MySQL parameter group family"
  type        = string
}

variable "cluster_identifier" {
  description = "RDS Cluster identifier"
  type        = list(string)
}

variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "publicly_accessible" {
  description = "Database publicly accessible"
  type        = bool
}

variable "master_username" {
  description = "Master username for database"
  type        = string
}

variable "master_password" {
  description = "Master password for database"
  type        = string
}

variable "performance_insights_enabled" {
  description = "Performance insights enabled for database"
  type        = bool
}

variable "ca_cert_identifier" {
  description = "CA certificate identifier for database"
  type        = string
}

variable "backup_retention_period" {
  description = "Backup retention period for database"
  type        = number
}

variable "preferred_backup_window" {
  description = "Preferred backup window for database"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot for database"
  type        = bool
}

variable "deletion_protection" {
  description = "Deletion protection for database"
  type        = bool
}

variable "max_connections" {
  description = "Max connections for database"
  type        = number
}

variable "eks_security_group_id" {
  description = "Security group ID for the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
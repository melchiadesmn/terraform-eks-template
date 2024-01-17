# General variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "000000000000"
}

variable "prefix_name" {
  description = "Prefix for resources"
  type        = string
  default     = "eks-staging"
}

variable "environment" {
  description = "Stack environment"
  type        = string
  default     = "staging"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    "user:Application" : "cluster",
    "user:Stack" : "staging",
    "user:CostCenter" : "technology"
  }
}

# VPC variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.200.0.0/16"
}

variable "subnet_cidr_blocks_public" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
}

variable "subnet_cidr_blocks_private" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.200.11.0/24", "10.200.12.0/24", "10.200.13.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# EKS variables
variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "eks-staging-cluster"
}

variable "eks_cluster_version" {
  description = "Version for eks cluster"
  type        = string
  default     = "1.28"
}

variable "addon_name" {
  description = "Addon name"
  type        = list(string)
  default     = ["aws-efs-csi-driver"]
}

variable "eks_roles" {
  description = "Existing Roles access EKS"
  type        = list(string)
  default     = ["Admin"]
}

variable "eks_users" {
  description = "Users access EKS"
  type        = list(string)
  default     = ["admin", "github"]
}

variable "key_name" {
  description = "Existing Key pair name"
  type        = string
  default     = "eks-devops"
}

variable "capacity_type" {
  description = "Capacity type for node group"
  type        = string
  default     = "ON_DEMAND"
}

variable "force_update_version" {
  description = "Force update version for node group"
  type        = bool
  default     = true
}

variable "system_instance_types" {
  description = "Instance types for system node group"
  type        = list(string)
  default     = ["m6i.large"]
}

variable "on_demand_instance_types" {
  description = "Instance types for on demand node groups"
  type        = list(string)
  default     = ["m6i.large"]
}

variable "spot_instance_types" {
  description = "Instance types for spot node groups"
  type        = list(string)
  default = [
    "c6i.large",
    "m6i.large",
    "t3.large",
    "t3a.large",
    "m5a.large",
    "m5d.large",
    "m5.large",
    "m4.large"
  ]
}

# EFS variables
variable "encrypted" {
  description = "EFS encrypted"
  type        = bool
  default     = true
}

variable "creation_token" {
  description = "EFS creation token"
  type        = list(string)
  default = [
    "efs-eks-prometheus-server"
  ]
}

# RDS variables
variable "pg_family" {
  description = "MySQL parameter group family"
  type        = string
  default     = "aurora-mysql8.0"
}

variable "cluster_identifier" {
  description = "RDS cluster indentifier"
  type        = list(string)
  default = [
    "eks-staging-aurora"
  ]
}

variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t4g.large"
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.04.0"
}

variable "publicly_accessible" {
  description = "Database publicly accessible"
  type        = bool
  default     = false
}

variable "master_username" {
  description = "Master username for database"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Master password for database"
  type        = string
  default     = "Wjq7o3j3"
}

variable "performance_insights_enabled" {
  description = "Performance insights enabled for database"
  type        = bool
  default     = true
}

variable "ca_cert_identifier" {
  description = "CA certificate identifier for database"
  type        = string
  default     = "rds-ca-rsa2048-g1"
}

variable "backup_retention_period" {
  description = "Backup retention period for database"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window for database"
  type        = string
  default     = "03:00-06:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot for database"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Deletion protection for database"
  type        = bool
  default     = true
}

variable "max_connections" {
  description = "Max connections for database"
  type        = number
  default     = 683
}

# Helm variables
variable "aws_lb_chart_version" {
  description = "AWS Load Balancer Controller Chart version"
  type        = string
  default     = "1.5.4"
}

variable "aws_lb_app_version" {
  description = "AWS Load Balancer Controller Application version"
  type        = string
  default     = "2.5.3"
}

variable "aws_registry_url" {
  description = "AWS container registry Url"
  type        = string
  default     = "602401143452.dkr.ecr.sa-east-1.amazonaws.com"
}

variable "metric_server_chart_version" {
  description = "Metric Server Chart version"
  type        = string
  default     = "3.10.0"
}

variable "cluster_autoscaler_chart_version" {
  description = "Cluster Autoscaler Chart version"
  type        = string
  default     = "9.29.1"
}

variable "kube_state_metrics_chart_version" {
  description = "Kube State Metrics Chart version"
  type        = string
  default     = "3.5.9"
}

variable "prometheus_chart_version" {
  description = "Prometheus Chart version"
  type        = string
  default     = "23.3.0"
}

variable "prometheus_certificate_arn" {
  description = "Prometheus Certificate ARN"
  type        = string
  default     = "arn:aws:acm:us-east-1:000000000000:certificate/12b912b9-2cf8-450f-a640-a39baeah3dbc"
}

variable "prometheus_host" {
  description = "Prometheus Host"
  type        = string
  default     = "staging-prometheus-example.com"
}

variable "grafana_chart_version" {
  description = "Grafana Chart version"
  type        = string
  default     = "7.0.11"
}

variable "grafana_certificate_arn" {
  description = "Grafana Certificate ARN"
  type        = string
  default     = "arn:aws:acm:us-east-1:000000000000:certificate/12b912b9-2cf8-450f-a640-a39baeah3dbc"
}

variable "grafana_host" {
  description = "Grafana Host"
  type        = string
  default     = "grafana.example.com"
}

# K8s variables
variable "namespaces" {
  description = "Namespaces"
  type        = list(string)
  default = [
    "eks-staging",
    "eks-devops-monitoring"
  ]
}

# Backup Variables
variable "backup_resources" {
  description = "Resources ID to backup"
  type        = list(string)
  default     = [ "i-008434acdbf4eae174" ]
}
module "vpc" {
  source = "../../modules/vpc"

  aws_region                 = var.aws_region
  vpc_cidr_block             = var.vpc_cidr_block
  subnet_cidr_blocks_private = var.subnet_cidr_blocks_private
  subnet_cidr_blocks_public  = var.subnet_cidr_blocks_public
  availability_zones         = var.availability_zones
  cluster_name               = var.cluster_name
  prefix_name                = var.prefix_name
  environment                = var.environment
  tags                       = var.tags
}

module "iam" {
  source = "../../modules/iam"

  aws_lb_app_version          = var.aws_lb_app_version
  openid_connect_provider_arn = module.eks.openid_connect_provider_arn
  openid_connect_provider_url = module.eks.openid_connect_provider_url
  environment                 = var.environment
  tags                        = var.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name             = var.cluster_name
  eks_cluster_version      = var.eks_cluster_version
  addon_name               = var.addon_name
  eks_cluster_role         = module.iam.eks_cluster_role
  subnet_ids               = module.vpc.private_subnet_ids
  eks_cluster_policy       = module.iam.eks_cluster_policy
  eks_nodegroup_role       = module.iam.eks_nodegroup_role
  eks_nodegroup_policy     = module.iam.eks_nodegroup_policy
  eks_cni_policy           = module.iam.eks_cni_policy
  eks_ecr_policy           = module.iam.eks_ecr_policy
  aws_region               = var.aws_region
  prefix_name              = var.prefix_name
  environment              = var.environment
  key_name                 = var.key_name
  capacity_type            = var.capacity_type
  force_update_version     = var.force_update_version
  system_instance_types    = var.system_instance_types
  on_demand_instance_types = var.on_demand_instance_types
  spot_instance_types      = var.spot_instance_types
  tags                     = var.tags

  depends_on = [
    module.vpc,
    module.iam.eks_cluster_role,
    module.iam.eks_cluster_policy
  ]
}

module "efs" {
  source = "../../modules/efs"

  prefix_name           = var.prefix_name
  vpc_id                = module.vpc.vpc_id
  eks_security_group_id = module.eks.eks_security_group_id
  encrypted             = var.encrypted
  creation_token        = var.creation_token
  subnet_ids            = module.vpc.private_subnet_ids
  tags                  = var.tags

  depends_on = [module.vpc, module.eks]
}

module "k8s" {
  source = "../../modules/k8s"

  namespaces         = var.namespaces
  efs_resources      = module.efs.efs_resources
  eks_nodegroup_role = module.iam.eks_nodegroup_role
  aws_account_id     = var.aws_account_id
  eks_roles          = var.eks_roles
  eks_users          = var.eks_users

  depends_on = [module.eks, module.efs]
}

module "aws_lb_controller" {
  source = "../../addons/alb-controller"

  aws_registry_url       = var.aws_registry_url
  aws_lb_chart_version   = var.aws_lb_chart_version
  cluster_name           = module.eks.cluster_name
  aws_region             = var.aws_region
  vpc_id                 = module.vpc.vpc_id
  lb_controller_role_arn = module.iam.lb_controller_role_arn

  depends_on = [module.eks, module.iam]
}

module "metric_server" {
  source = "../../addons/metric-server"

  metric_server_chart_version = var.metric_server_chart_version

  depends_on = [module.aws_lb_controller]
}

module "cluster_autoscaler" {
  source = "../../addons/cluster-autoscaler"

  cluster_autoscaler_chart_version = var.cluster_autoscaler_chart_version
  aws_region                       = var.aws_region
  eks_cluster_version              = var.eks_cluster_version
  cluster_name                     = module.eks.cluster_name
  cluster_autoscaler_role_arn      = module.iam.cluster_autoscaler_role_arn

  depends_on = [module.metric_server]
}

module "kube_state_metrics" {
  source = "../../addons/kube-state-metrics"

  kube_state_metrics_chart_version = var.kube_state_metrics_chart_version

  depends_on = [module.cluster_autoscaler]
}

module "prometheus" {
  source = "../../addons/prometheus"

  prometheus_chart_version   = var.prometheus_chart_version
  prometheus_certificate_arn = var.prometheus_certificate_arn
  prometheus_host            = var.prometheus_host

  depends_on = [module.kube_state_metrics, module.k8s]
}

module "grafana" {
  source = "../../addons/grafana"

  environment                = var.environment
  grafana_chart_version   = var.grafana_chart_version
  grafana_certificate_arn = var.grafana_certificate_arn
  grafana_host            = var.grafana_host

  depends_on = [module.prometheus]
}

module "rds" {
  source = "../../modules/rds"

  prefix_name                  = var.prefix_name
  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.private_subnet_ids
  availability_zones           = var.availability_zones
  pg_family                    = var.pg_family
  cluster_identifier           = var.cluster_identifier
  instance_class               = var.instance_class
  engine                       = var.engine
  engine_version               = var.engine_version
  publicly_accessible          = var.publicly_accessible
  master_username              = var.master_username
  master_password              = var.master_password
  performance_insights_enabled = var.performance_insights_enabled
  ca_cert_identifier           = var.ca_cert_identifier
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  skip_final_snapshot          = var.skip_final_snapshot
  deletion_protection          = var.deletion_protection
  max_connections              = var.max_connections
  eks_security_group_id        = module.eks.eks_security_group_id
  tags                         = var.tags

  depends_on = [module.eks]
}

module "bkp" {
  source = "../../modules/bkp"

  prefix_name = var.prefix_name
  resources   = var.backup_resources
  environment = var.environment
  tags        = var.tags

  depends_on = [module.waf]
}
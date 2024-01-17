resource "aws_eks_cluster" "eks" {
  name = var.cluster_name

  role_arn = var.eks_cluster_role.arn
  version  = var.eks_cluster_version

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = var.subnet_ids
  }

  depends_on = [
    var.eks_cluster_policy,
    var.subnet_ids
  ]

  tags = var.tags
}

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.oidc_thumbprint.result.thumbprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.eks]

  tags = merge(var.tags, {
    Name = "${var.prefix_name}-cluster-eks-irsa"
  })
}

resource "aws_eks_addon" "eks_addon" {
  for_each     = toset(var.addon_name)
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = each.key

  tags = var.tags

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_openid_connect_provider.eks_oidc_provider
  ]
}

resource "aws_launch_template" "launch_template_system" {
  name = "${var.prefix_name}-ng-system"

  key_name = var.key_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
  tags = var.tags
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      "Name" = "${var.prefix_name}-ng-system"
    })
  }
}

resource "aws_launch_template" "launch_template_app_spot" {
  name = "${var.prefix_name}-ng-app-spot"

  key_name = var.key_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
  tags = merge(var.tags, {
    "user:Application" : "app"
  })
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      "user:Application" : "app"
      "Name" = "${var.prefix_name}-ng-app-spot"
    })
  }
}

resource "aws_launch_template" "launch_template_app_m6" {
  name = "${var.prefix_name}-ng-app-m6"

  key_name = var.key_name
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
  tags = merge(var.tags, {
    "user:Application" : "app"
  })
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      "user:Application" : "app"
      "Name" = "${var.prefix_name}-ng-app-m6"
    })
  }
}

resource "aws_eks_node_group" "ng_system" {
  cluster_name = aws_eks_cluster.eks.name
  version      = var.eks_cluster_version

  node_group_name      = "ng-system-${var.environment}"
  node_role_arn        = var.eks_nodegroup_role.arn
  subnet_ids           = var.subnet_ids
  capacity_type        = var.capacity_type
  ami_type             = "AL2_x86_64"
  force_update_version = var.force_update_version
  instance_types       = var.system_instance_types
  launch_template {
    id      = aws_launch_template.launch_template_system.id
    version = aws_launch_template.launch_template_system.latest_version
  }
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  labels = {
    intent = "system"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_launch_template.launch_template_system,
    var.eks_nodegroup_policy,
    var.eks_cni_policy,
    var.eks_ecr_policy
  ]

  tags = var.tags

  lifecycle {
    ignore_changes = [ scaling_config ]
  }
}

resource "aws_eks_node_group" "ng_app_spot" {
  cluster_name = aws_eks_cluster.eks.name
  version      = var.eks_cluster_version

  node_group_name      = "ng-app-spot-${var.environment}"
  node_role_arn        = var.eks_nodegroup_role.arn
  subnet_ids           = var.subnet_ids
  capacity_type        = "SPOT"
  ami_type             = "AL2_x86_64"
  force_update_version = var.force_update_version
  instance_types       = var.spot_instance_types
  launch_template {
    id      = aws_launch_template.launch_template_app_spot.id
    version = aws_launch_template.launch_template_app_spot.latest_version
  }
  scaling_config {
    desired_size = 0
    max_size     = 7
    min_size     = 0
  }

  labels = {
    intent = "app-spot"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_launch_template.launch_template_app_spot,
    var.eks_nodegroup_policy,
    var.eks_cni_policy,
    var.eks_ecr_policy
  ]

  tags = merge(var.tags, {
    "user:Application" : "app"
  })

  lifecycle {
    ignore_changes = [ scaling_config ]
  }
}

resource "aws_eks_node_group" "ng_app_m6" {
  cluster_name = aws_eks_cluster.eks.name
  version      = var.eks_cluster_version

  node_group_name      = "ng-app-m6-${var.environment}"
  node_role_arn        = var.eks_nodegroup_role.arn
  subnet_ids           = var.subnet_ids
  capacity_type        = var.capacity_type
  ami_type             = "AL2_x86_64"
  force_update_version = var.force_update_version
  instance_types       = var.on_demand_instance_types
  launch_template {
    id      = aws_launch_template.launch_template_app_m6.id
    version = aws_launch_template.launch_template_app_m6.latest_version
  }
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  labels = {
    intent = "app-m6"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_launch_template.launch_template_app_m6,
    var.eks_nodegroup_policy,
    var.eks_cni_policy,
    var.eks_ecr_policy
  ]

  tags = merge(var.tags, {
    "user:Application" : "app"
  })
}

resource "aws_autoscaling_schedule" "asg_awake_schedule_system" {
  count = var.environment == "staging" ? 1 : 0

  scheduled_action_name = "awake"
  min_size              = 0
  max_size              = 2
  desired_capacity      = 1
  recurrence            = "0 11 * * 1-5"

  autoscaling_group_name = aws_eks_node_group.ng_system.resources[0].autoscaling_groups[0].name
}

resource "aws_autoscaling_schedule" "asg_sleep_schedule_system" {
  count = var.environment == "staging" ? 1 : 0

  scheduled_action_name = "sleep"
  min_size              = 0
  max_size              = 0
  desired_capacity      = 0
  recurrence            = "0 22 * * 1-5"

  autoscaling_group_name = aws_eks_node_group.ng_system.resources[0].autoscaling_groups[0].name
}

resource "aws_autoscaling_schedule" "asg_awake_schedule_app_spot" {
  count = var.environment == "staging" ? 1 : 0

  scheduled_action_name = "awake"
  min_size              = 0
  max_size              = 6
  desired_capacity      = 0
  recurrence            = "0 11 * * 1-5"

  autoscaling_group_name = aws_eks_node_group.ng_app_spot.resources[0].autoscaling_groups[0].name
}

resource "aws_autoscaling_schedule" "asg_sleep_schedule_app_spot" {
  count = var.environment == "staging" ? 1 : 0

  scheduled_action_name = "sleep"
  min_size              = 0
  max_size              = 0
  desired_capacity      = 0
  recurrence            = "0 22 * * 1-5"

  autoscaling_group_name = aws_eks_node_group.ng_app_spot.resources[0].autoscaling_groups[0].name
}

resource "aws_autoscaling_schedule" "asg_awake_schedule_app_m6" {
  count = var.environment == "staging" ? 1 : 0

  scheduled_action_name = "awake"
  min_size              = 0
  max_size              = 1
  desired_capacity      = 1
  recurrence            = "0 11 * * 1-5"

  autoscaling_group_name = aws_eks_node_group.ng_app_m6.resources[0].autoscaling_groups[0].name
}

resource "aws_autoscaling_schedule" "asg_sleep_schedule_app_m6" {
  count = var.environment == "staging" ? 1 : 0

  scheduled_action_name = "sleep"
  min_size              = 0
  max_size              = 0
  desired_capacity      = 0
  recurrence            = "0 22 * * 1-5"

  autoscaling_group_name = aws_eks_node_group.ng_app_m6.resources[0].autoscaling_groups[0].name
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.eks.name

  depends_on = [aws_eks_cluster.eks]
}

data "external" "oidc_thumbprint" {
  program = ["bash", "scripts/thumbprint.sh", var.aws_region]
}
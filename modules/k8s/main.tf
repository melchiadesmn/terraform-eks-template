resource "kubernetes_namespace" "namespaces" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.key
  }
}

resource "kubernetes_storage_class" "storage_classes" {
  metadata {
    name = "efs"
  }
  storage_provisioner = "efs.csi.aws.com"
}

resource "kubernetes_persistent_volume" "prometheus_pv" {
  metadata {
    name = "efs-prometheus-server-pv"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    capacity = {
      storage = "15Gi"
    }
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "efs"
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = var.efs_resources["efs-eks-prometheus-server"].id
      }
    }
  }

  depends_on = [
    kubernetes_namespace.namespaces
  ]
}

resource "kubernetes_persistent_volume_claim" "prometheus_pvc" {
  metadata {
    name      = "efs-prometheus-server-claim"
    namespace = "mirum-devops-monitoring"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "15Gi"
      }
    }
    storage_class_name = "efs"
  }

  depends_on = [
    kubernetes_persistent_volume.prometheus_pv
  ]
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  force = true

  data = {
    mapRoles = yamlencode(
      concat(
        [
          {
            "rolearn" : var.eks_nodegroup_role.arn
            "username" : "system:node:{{EC2PrivateDNSName}}"
            "groups" : ["system:bootstrappers", "system:nodes"]
          }
        ],
        [
          for role in var.eks_roles : {
            "rolearn" : "arn:aws:iam::${var.aws_account_id}:role/${role}",
            "username" : "${role}",
            "groups" : ["system:masters"]
          }
      ])
    )
    mapUsers = yamlencode(
      [
        for user in var.eks_users : {
          "userarn" : "arn:aws:iam::${var.aws_account_id}:user/${user}",
          "username" : "${user}",
          "groups" : ["system:masters"]
        }
      ]
    )
  }
}
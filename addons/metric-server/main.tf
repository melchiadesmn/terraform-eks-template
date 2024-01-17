resource "helm_release" "metric_server" {
  name       = "metric-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = var.metric_server_chart_version

  namespace = "kube-system"

  set {
    name  = "apiService.create"
    value = "true"
  }

  set {
    name  = "nameOverride"
    value = "metric-server"
  }

  set {
    name  = "resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "resources.limits.memory"
    value = "1Gi"
  }

  set {
    name  = "nodeSelector.intent"
    value = "system"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "metric-server"
  }
}
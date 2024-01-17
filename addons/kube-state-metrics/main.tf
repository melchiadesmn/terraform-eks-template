resource "helm_release" "kube_state_metrics" {
  name       = "kube-state-metrics"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kube-state-metrics"
  version    = var.kube_state_metrics_chart_version

  namespace = "kube-system"

  set {
    name  = "nameOverride"
    value = "kube-state-metrics"
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
}
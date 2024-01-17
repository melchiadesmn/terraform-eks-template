resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_chart_version

  namespace = "mirum-devops-monitoring"

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-pushgateway.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-node-exporter.enabled"
    value = "false"
  }

  set {
    name  = "kube-state-metrics.enabled"
    value = "false"
  }

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "server.resources.limits.memory"
    value = "2Gi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "1"
  }

  set {
    name  = "server.securityContext.fsGroup"
    value = "0"
  }

  set {
    name  = "server.securityContext.runAsGroup"
    value = "0"
  }

  set {
    name  = "server.securityContext.runAsNonRoot"
    value = "false"
  }

  set {
    name  = "server.securityContext.runAsUser"
    value = "0"
  }

  set {
    name  = "server.nodeSelector.intent"
    value = "system"
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = "true"
  }

  set {
    name  = "server.persistentVolume.existingClaim"
    value = "efs-prometheus-server-claim"
  }

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internal"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "app-internal"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"
    value = "[{\"HTTPS\":443}]"
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = var.prometheus_certificate_arn
  }

  set {
    name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/load-balancer-attributes"
    value = "routing.http2.enabled=true"
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "alb"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = var.prometheus_host
  }
}
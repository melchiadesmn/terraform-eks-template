resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_chart_version

  namespace = "procurabem-devops"

  set {
    name  = "resources.requests.memory"
    value = "500Mi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.limits.memory"
    value = "750Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "300m"
  }

  set {
    name  = "nodeSelector.intent"
    value = "system"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "envFromSecret"
    value = "database-credentials"
  }

  set {
    name  = "grafana\\.ini.database.type"
    value = "mysql"
  }

  set {
    name  = "grafana\\.ini.database.host"
    value = "$\\{DB_HOST}"
  }

  set {
    name  = "grafana\\.ini.database.name"
    value = "$\\{DB_DATABASE}"
  }

  set {
    name  = "grafana\\.ini.database.user"
    value = "$\\{DB_USERNAME}"
  }

  set {
    name  = "grafana\\.ini.database.password"
    value = "$\\{DB_PASSWORD}"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.ingressClassName"
    value = "alb"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internet-facing"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/group\\.name"
    value = "app-internal"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/healthcheck-path"
    value = "/api/health"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"
    value = "[{\"HTTPS\":443}]"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
    value = var.grafana_certificate_arn
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/load-balancer-attributes"
    value = "routing.http2.enabled=true"
  }

  set {
    name  = "ingress.hosts[0]"
    value = var.grafana_host
  }
}
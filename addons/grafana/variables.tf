variable "environment" {
  description = "Environment resource"
  type        = string
}

variable "grafana_chart_version" {
  description = "Grafana Chart version"
  type        = string
}

variable "grafana_certificate_arn" {
  description = "Grafana Certificate ARN"
  type        = string
}

variable "grafana_host" {
  description = "Grafana Host"
  type        = string
}
output "metric_server_arn" {
  description = "Metric Server ARN"
  value       = helm_release.metric_server.metadata.0.name
}
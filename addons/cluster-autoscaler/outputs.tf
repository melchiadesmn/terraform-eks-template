output "cluster_autoscaler_arn" {
  description = "Cluster Autoscaler ARN"
  value       = helm_release.cluster_autoscaler.metadata.0.name
}
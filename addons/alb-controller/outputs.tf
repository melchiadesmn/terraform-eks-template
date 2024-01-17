output "aws_load_balancer_controller_arn" {
  description = "ARN do AWS Load Balancer Controller"
  value       = helm_release.aws_load_balancer_controller.metadata.0.name
}
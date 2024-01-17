output "eks_cluster_role" {
  value = aws_iam_role.eks_cluster_role
}

output "eks_cluster_policy" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy
}

output "eks_nodegroup_role" {
  value = aws_iam_role.eks_nodegroup_role
}

output "eks_nodegroup_policy" {
  value = aws_iam_role_policy_attachment.eks_nodegroup_policy
}

output "eks_cni_policy" {
  value = aws_iam_role_policy_attachment.eks_cni_policy
}

output "eks_ecr_policy" {
  value = aws_iam_role_policy_attachment.eks_ecr_policy
}

output "lb_controller_role_arn" {
  value = aws_iam_role.lb_controller_role.arn
}

output "cluster_autoscaler_role_arn" {
  value = aws_iam_role.cluster_autoscaler_role.arn
}
output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.eks_oidc_provider.arn
}

output "openid_connect_provider_url" {
  value = aws_iam_openid_connect_provider.eks_oidc_provider.url
}

output "eks_security_group_id" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}
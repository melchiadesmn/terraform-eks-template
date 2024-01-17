output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_ca_certificate
}
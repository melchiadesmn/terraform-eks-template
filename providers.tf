terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
  }
}

provider "kubernetes" {
  host                   = local.cluster_endpoint[local.environment]
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate[local.environment])
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name[local.environment]]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = local.cluster_endpoint[local.environment]
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate[local.environment])
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name[local.environment]]
      command     = "aws"
    }
  }
}